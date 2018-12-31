---
title: "Final Exam"
excerpt: "Answers to Final Exam Problems from Algorithms Design and Analysis II Course."
mathjax: true
---
> Consider a connected undirected graph with distinct edge costs. Which of the following are true? [Check all that apply.]
* Suppose the edge $$ e $$ is not the cheapest edge that crosses the cut $$ (A,B) $$. Then $$ e $$ does not belong to any minimum spanning tree.
* Suppose the edge $$ e $$ is the most expensive edge contained in the cycle $$ C $$. Then $$ e $$ does not belong to any minimum spanning tree.
* The minimum spanning tree is unique.
* Suppose the edge $$ e $$ is the cheapest edge that crosses the cut $$ (A,B) $$. Then $$ e $$ belongs to every minimum spanning tree.

**ANSWER:** Option 3 is correct because the edge weights are distinct. Options 2 and 4 follow from the Cut Property based on the correctness of option 3 and are correct as well.

Consider the following graph, where cost of edge $$ A-B $$ is greater than the cost of edge $$ C-D $$. Edges $$ A-B $$ and $$ C-D $$ are both included in the MST, even though $$ A-B $$ isn't the cheapest edge crossing the cut shown.
```
   X
A+-X--+B
   X   +
   X   |
   X   +
D+-X--+C
   X
```
Thus, option 1 is incorrect.

> Which of the following graph algorithms can be sped up using the heap data structure?
* Dijkstra's single-source shortest-path algorithm (from Part 2).
* Prim's minimum-spanning tree algorithm.
* Our dynamic programming algorithm for computing a maximum-weight independent set of a path graph.
* Kruskal's minimum-spanning tree algorithm.

**ANSWER:** Options 1 and 2 are correct. MWIS doesn't consider the edges in sorted order, so a heap won't help. Kruskal's algorithm requires the edges to be sorted, which can be done by using a min-heap, but it won't provide any speed up over a fast comparison sort.

> Which of the following problems reduce, in a straightforward way, to the minimum spanning tree problem? [Check all that apply.]
* The maximum-cost spanning tree problem. That is, among all spanning trees of a connected graph with edge costs, compute one with the maximum-possible sum of edge costs.
* The minimum bottleneck spanning tree problem. That is, among all spanning trees of a connected graph with edge costs, compute one with the minimum-possible maximum edge cost.
* The single-source shortest-path problem.
* Given a connected undirected graph $$ G = (V,E) $$ with positive edge costs, compute a minimum-cost set $$ F \subseteq E $$ such that the graph $$ (V,E-F) $$ is acyclic.

**ANSWER:** If we negate the weights of all edges, a minimum-cost spanning tree algorithm yields a maximum-cost spanning tree. Thus, option 1 is correct.

A minimum bottleneck spanning tree is also a MST. Thus, option 2 is correct.

Option 4 is also correct since a MST, by definition, doesn't have a cycle. However, it's not clear to me what prevents is to take only a single edge. There's nothing in the question that indicates $$ (V,E-F) $$ needs to be connected.

Option 3 is incorrect; this problem doesn't consider edge costs.

> Recall the greedy clustering algorithm from lecture and the max-spacing objective function. Which of the following are true? [Check all that apply.]
* If the greedy algorithm produces a $$ k $$-clustering with spacing $$ S $$, then every other $$ k $$-clustering has spacing at most $$ S $$.
* Suppose the greedy algorithm produces a $$ k $$-clustering with spacing $$ S $$. Then, if $$ x,y $$ are two points in a common cluster of this $$ k $$-clustering, the distance between $$ x $$ and $$ y $$ is at most $$ S $$.
* If the greedy algorithm produces a $$ k $$-clustering with spacing $$ S $$, then the distance between every pair of points chosen by the greedy algorithm (one pair per iteration) is at most $$ S $$.
* This greedy clustering algorithm can be viewed as Prim's minimum spanning tree algorithm, stopped early.

**ANSWER:** Option 1 is correct; the greedy algorithm is optimal.

Option 2 is incorrect. The greedy algorithm merges closest points as long as the number of clusters is less than or equal to $$ k $$. If the distance between $$ x,y $$ was at most $$ S $$, they would've been merged.

Option 3 is correct.

Option 4 is incorrect. The greedy algorithm can be viewed as Kruskal's algorithm stopped early, not Prim's.