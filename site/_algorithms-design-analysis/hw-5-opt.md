---
title: "Homework 5 Optional Problems"
excerpt: "Answers to Homework 5 Optional Problems from Algorithms Design and Analysis Course."
mathjax: true
---
> In lecture we define the length of a path to be the sum of the lengths of its edges. Define the bottleneck of a path to be the maximum length of one of its edges. A mininum-bottleneck path between two vertices $$ s $$ and $$ t $$ is a path with bottleneck no larger than that of any other $$ s-t $$ path. Show how to modify Dijkstra's algorithm to compute a minimum-bottleneck path between two given vertices. The running time should be $$ O(m\log n) $$, as in lecture.

**ANSWER:** Each iteration is analogous to finding the winner of a two-round tournament. In the first round, we find the bottlenecks for all the paths until that point; in the second round, we find the minimum of all such bottlenecks.

$$
\begin{multline*}
  dist(v) = \min(dist(v), \max(dist(u), weight(u, v))) \\
   \forall u \in X, v \in V - X
\end{multline*}
$$

We start by inserting $$(\infty, u) \ u \in V $$ in a min-heap. We decrease the key of the source to $$ -\infty $$. Then in each iteration, we extract the minimum from the heap, add it to set $$ X $$, and update the keys for the adjacent vertices according to the formula above.

The only thing we changed from Dijkstra's algorithm is the scoring formula, which now involves some constant time operations for $$ \min $$ and $$ \max $$. Thus, running time of the above algorithm is the same as that of Dijkstra's, $$ O(m\log n) $$.

This problem is also known as the **minimax path problem**. A variation of it is the [widest path problem](https://en.wikipedia.org/wiki/Widest_path_problem), or the maximum-capacity problem, where we try to maximize the capacity of a path, which in turn is defined as the minimum length of one of its edges.

> We can do better. Suppose now that the graph is undirected. Give a linear-time $$ O(m) $$ algorithm to compute a minimum-bottleneck path between two given vertices.

**ANSWER:** The idea is as follows:

```
1: CRITICAL-EDGE(G, s, t)
2:   if |E(G)| == 1
3:     return the only edge
4:   else
5:     x = median of all edge weights
6:     X = E - (v, w) s.t. weight(v, w) > x
7:     G' = G(V, X)
8:     exists = is there a path from s to t in G'

9:     if (exists == FALSE)
10:      C = {C₁, C₂, ..., Cₖ} s.t. Cᵢ is a connected component of G
11:      G' = G(V, E - X)

12:      for i = 1 to |C|
13:        G' = SHRINK(G', C, i)
14:    else if X == E // no edges were deleted
15:      X = {(v, w)} s.t. weight(v, w) = x
16:      G' = G(V, X)

17:  return CRITICAL-EDGE(G', s, t)

18: SHRINK(G, C, i)
19:   leaderᵢ = leader vertex of C[i]
20:   V* = {V(G) - C[i]} ∪ {leaderᵢ}

21:   E* = {}
22:   for each (v, w) ∈ E(G)
23:     if v ∈ C[i], w ∈ C[j]
24:       E* = E* ∪ {(leaderᵢ, leaderⱼ, min(weight(u, w)))} ∀ u ∈ C[i]
25:     else if v, w ∉ C[i]
          E * = E* ∪ {(v, w, weight(v, w))}

26:   return G*(V*, E*)
```

* 5: can be done using Randomized Linear-Time Selection; $$ O(m) $$
* 8: can be done by running BFS and stopping when $$ t $$ is visited; $$ O(m + n) $$
* 10: can be done using Kosaraju's algorithm; $$ O(m + n) $$
* 11: can be done in $$ O(\frac{m}{2}) $$
* 20: can be done in linear time of $$ V(C[i]) $$
* 22: can be done in $$ O(\frac{m}{2}) $$
* 24: can be done by knowing all edges incident with $$ w $$; the graph would need to support such query in constant time, likely at the expense of increased memory usage
* 13: $$ O(m) $$ (max work done in $$ SHRINK $$)

The correctness of $$ CRITICAL-EDGE $$ can be argued as follows:

If in line 8 it turns out that the graph still is s-t-connected, then deleting the edges of weights greater than $$ x $$ in line 6 did not affect the optimal solution. By recursing on the resulting graph, we converge on smaller edge weights that possibly maintain s-t-connectivity.

Otherwise, clearly $$ s $$ and $$ t $$ are in different connected components, and the bottleneck of path $$ s-t $$ is at least $$ x $$. In line 24, if there are more than one edges between two connected components, choosing the minimum is consistent with our goal find the minimum bolttleneck. If we chose the maximum instead, we would lose the path that has a smaller edge weight, and could eventually become the minimum bolttleneck path.

The algorithm runs in time $$ O(m) $$, where $$ m = |E| $$ denotes the number of edges: The crucial observation is that in every recursive call, half of the edges are removed from the graph, either by shrinking all "thin" edges or by dropping all "thick" edges. As shown above, the work done outside the recursive call is $$ O(m) $$. Thus, the total running time is bounded by:
$$ O(m) + O(\frac{m}{2}) + O(\frac{m}{4}) + ... = O(m) $$

Having found the critical edge, we run BFS ignoring all edges with weight greater than the cricital edge. That takes linear time ($$ O(m) $$).

> What if the graph is directed? Can you compute a minimum-bottleneck path between two given vertices faster than $$ O(m\log n) $$?

**ANSWER:** [This](/assets/docs/algorithms-curated/On the Bottleneck Shortest Path Problem.pdf) paper argues that the above algorithm doesn't work for directed graphs because:
> the shrinking step in line 13 will not significantly reduce the number of edges, since it need not to be true that every "thin" edge is contained in some strongly connected component.

However, I have yet to convince myself of the above argument. The paper also offers a linear-time algorithm for computing a minimum-bottleneck path in directed graphs but it looks quite complicated.

If the edge weights are integral and drawn from a small range such that the maximum edge weight is known, then [this](/assets/docs/algorithms-curated/Dijkstra’s Algorithm with simple buckets - MIT 15.082J.pdf) lecture presents a modified Dijkstra's algorithm using buckets, aka Dial's implementation. There are a few ways of improving the time complexity of this algorithm.
1. We can use a circular queue of size $$ W + 2 $$, where $$ W $$ is the maximum edge weight. The bucket corresponding to $$ dist(v) $$ is simply $$ dist(v)\ mod\ (W + 1) $$. Last bucket contains the vertices not yet visited, corresponding to distance $$ \infty $$.
2. By maintaining a distance to heap index hash table, we can do distance updates in constant time. Note that the heap property is not violated if a vertex is moved bwteen buckets. It's only when a buket is inserted or deleted, we need to worry about restoring the heap property.

Since the heap always contains no more than $$ W + 2 $$ buckets, any operation takes $$ O(\log W) $$ time, thus giving us a running time of $$ O(m + n)\log W = O(m\log W) $$, based on the assumption that every vertex is reachable from the source vertex $$ s $$, and thus, $$ m \geq n - 1 $$ (see lecture video for details).