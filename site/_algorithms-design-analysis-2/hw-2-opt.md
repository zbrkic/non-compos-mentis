---
title: "Homework 2 Optional Problems"
excerpt: "Answers to Homework 2 Optional Problems from Algorithms Design and Analysis II Course."
mathjax: true
---
> Consider a connected undirected graph $$ G $$ with edge costs, which need not be distinct. Prove the following statement or provide a counterexample: for every MST $$ T $$ of $$ G $$, there exists a way to sort $$G $$'s edges in nondecreasing order of cost so that Kruskal's algorithm outputs the tree $$ T $$.

**ANSWER:** Given a MST $$ T $$, to obtain this tree with Kruskal's algorithm, we order the edges first by their weight, and resolve ties by picking an edge first if it is contained in $$ T $$. With this ordering, we will find $$ T $$.

> Consider a connected undirected graph $$ G $$ with distinct edge costs that are positive integers between $$ 1 $$ and $$ n^3 $$, where $$ n $$ is the number of vertices of $$ G $$. How fast can you compute the MST of $$ G $$?

**ANSWER:** We may use [Radix Sort](https://en.wikipedia.org/wiki/Radix_sort) instead of a comparison sort to sort in linear time. We don't use [Counting Sort](https://en.wikipedia.org/wiki/Counting_sort) [^1] because it's going to take $$ O(n^3) $$ time to go over the buckets. In general, Counting sort takes $$ O(k + n) $$ time, where $$ n $$ is the size of the input and $$ k $$ is the maximum value of the keys. Once sorted, we may use Kruskal's algorithm to compute the MST in linear time.

> Read about matroids. Prove that the greedy algorithm correctly computes a maximum-weight basis. For the matroid of spanning trees of a graph, this algorithm becomes Kruskal's algorithm. Can you formulate an analog of Prim's MST algorithm for matroids?

**ANSWER:** CLRS section 16.4 has an excellent introduction to Matroids. Also see the Metroid section in the [curated list](/algorithms-curated/). Quoting CLRS:
> A _graphic matroid_ $$ M_G = (S_G,I_G) $$ defined in terms of a given undirected graph $$ G = (V,E) $$ as follows:
* The set $$ S_G $$ is defined to be $$ E $$, the set of edges of $$ G $$.
* If $$ A $$ is a subset of $$ E $$, then $$ A \in I_G $$ iff $$ A $$ is acyclic. That is, a set of edges $$ A $$ is independent if and only if the subgraph $$ G_A = (V,A) $$ forms a forest.

If we define the weight function such that weight $$ w_e $$ of an edge $$e $$ is given by $$ {w_e}_{max \forall e} - w_e $$, then Kruskal's algorithm becomes a special case of the algorithm $$ GREEDY(M,w) $$ in CLRS.

Prim's algorithm, on the other hand, maintains an induced subgraph $$ F = (V' \subseteq V, E' \subseteq E \mid e(v,w) \in E' \iff v, w \in V') $$. For connected graphs, $$ F $$ is a tree, but $$ (E, F) $$ is not a Matroid since it doesn't satisfy the hereditary property; removing an edge from a tree may render it disconnected. Therefore, it can't be formulated in terms of greedy algorithm for Matroids.

> Prove that our analysis of union-find with lazy unions and union by rank (but without path compression) is asymptotically optimal (i.e., there are sequences of operations where you do $$ \Theta(\log n) $$ work on most of the operations).

**ANSWER:** The upper bound is proven is lecture video 7.3. For the lower bound, consider doing a find operation on the leaf node in a path of length $$ \log n $$ (the longest possible). Since we must traverse all nodes on the way to the root, the time taken is equal to the length of the path. Thus, time complexity of find is $$ \Theta(\log n) $$.

> Prove that in our union-find data structure with lazy unions, union by rank, and path compression, some operations might require $$ \Theta(\log n) $$ time.

**ANSWER:** See Tarjan's paper in the [curated list](/algorithms-curated/).

## References

[^1]: [Lecture 10a: Bucket Sort, Counting Sort - Richard Buckland](https://www.youtube.com/watch?v=3mxp4JLGasE)
