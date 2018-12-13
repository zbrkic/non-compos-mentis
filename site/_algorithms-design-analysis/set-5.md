---
title: "Problem Set 5"
excerpt: "Answers to Problem Set 5 from Algorithms Design and Analysis Course."
mathjax: true
---
> Consider a directed graph with distinct and nonnegative edge lengths and a source vertex . Fix a destination vertex , and assume that the graph contains at least one - path.
>
> Which of the following statements are true? Check all that apply.
* The shortest (i.e., minimum-length) $$ s-t $$ path might have as many as $$ n -1 $$ edges, where $$ n $$ is the number of vertices.
* There is a shortest $$ s-t $$ path with no repeated vertices (i.e., a "simple" or "loopless" such path).
* The shortest $$ s-t $$ path must include the minimum-length edge of $$ G $$.
* The shortest $$ s-t $$ path must exclude the maximum-length edge of $$ G $$.

**ANSWER:** Consider a directed path with no cycles, and $$ s $$ and $$ t $$ are at the two ends, they have $$ n -1 $$ edges between them. Thus, option 1 is correct. By the same argument, option 2 is correct. Options 3 and 4 are indeterministic; the length of the shortest path depends on _all_ the edges in the path, so, including or excluding the minimum-length edge or the maximum-length edge doesn't guarantee minimal path length; there may be other edges, large or small enough, that dominate the total length.

> Consider a directed graph $$ G = (V, E) $$ and a source vertex $$ s $$ with the following properties: edges that leave the source vertex $$ s $$ have arbitrary (possibly negative) lengths; all other edge lengths are nonnegative; and there are no edges from any other vertex to the source $$ s $$.
>
> Does Dijkstra's shortest-path algorithm correctly compute shortest-path distances (from $$ s $$) in this graph?
* Only if we add the assumption that $$ G $$ contains no directed cycles with negative total weight.
* Never
* Maybe, maybe not (depends on the graph)
* Always

**ANSWER:** Dijkstra's algorithm will work just fine. One approach is to see that the proof of correctness from the videos still works. A slicker solution is to notice that adding a positive constant $$ M $$ to all edges incident to $$ s $$ increases the length of every $$ s \rightarrow v $$ path by exactly $$ M $$, and thus preserves the shortest path.
Intuitively, in the first iteration, it chooses the smallest outgoing edge from $$ s $$, perhaps negative. Second iteration onwards, it correctly chooses the edge with the minimum Dijkstra score. It's possible that the chosen minimum $$ s \rightarrow x $$ is followed by a very long edge, but it won't be chosen in the second iteration if there're shorter ones.

> Suppose you implement the functionality of a priority queue using a sorted array (e.g., from biggest to smallest).
>
> What is the worst-case running time of Insert and Extract-Min, respectively? (Assume that you have a large enough array to accommodate the Insertions that you face.)
* \\(\Theta(n)\\) and \\(\Theta(n)\\)
* \\(\Theta(1)\\) and \\(\Theta(n)\\)
* \\(\Theta(\log n)\\) and \\(\Theta(1)\\)
* \\(\Theta(n)\\) and \\(\Theta(1)\\)

**ANSWER:** In the worst case, Insert may need to move all elements of the array to the right (if we get an element bigger than the first one). Extract-Min is simply a constant-time lookup of the last index of the array. Thus, option 4 is correct.

> Suppose you implement the functionality of a priority queue using a _unsorted_ array.
>
> What is the worst-case running time of Insert and Extract-Min, respectively? (Assume that you have a large enough array to accommodate the Insertions that you face.)
* \\(\Theta(1)\\) and \\(\Theta(n)\\)
* \\(\Theta(n)\\) and \\(\Theta(1)\\)
* \\(\Theta(n)\\) and \\(\Theta(n)\\)
* \\(\Theta(1)\\) and \\(\Theta(n)\\)

**ANSWER:** The worst case running time for insertion is easy, we can simply append it in the end of the unsorted array in constant time. For extracting the minimum element, we may need to look at all the elements. Thus, option 4 is correct.

> You are given a heap with $$ n $$ elements that supports Insert and Extract-Min.
>
> Which of the following tasks can you achieve in $$ O(\log n) $$ time?
* None of these
* Find the largest element stored in the heap
* Find the median of the elements stored in the heap
* Find the fifth-smallest element stored in the heap

**ANSWER:** Finding the fifth-smallest element from a min-heap takes five calls, each $$ O(\log n) $$ worst-case time. If we insert all the number by negating them first, we can find the largest element stored in the heap, but since this is not mentioned in the question, we have to assume that we're not allowed to do that. Finding the median can be done with two heaps, min-heap and max-heap, and the max-heap can be built by inserting the negative of the numbers, but again, this is not mentioned in the question. Thus, only option 4 is correct.

> Consider a directed graph $$ G $$ with a source vertex $$ s $$, a destination $$ t $$, and nonnegative edge lengths. Under what conditions is the shortest $$ s-t $$ path guaranteed to be unique?
* When all edge lengths are distinct positive integers.
* None of the other options are correct.
* When all edges lengths are distinct positive integers and the graph $$ G $$ contains no directed cycles.
* When all edge lengths are distinct powers of 2.

**ANSWER:** Consider a graph $$ G $$ with edges $$ s \xrightarrow{1} v, v \xrightarrow{2} t, s \xrightarrow{3} t $$. Even though all edge lengths are distinct positive integers, there exist two shortest paths, $$ s \rightarrow v \rightarrow t $$, and $$ s \rightarrow t $$; thus, option 1 is incorrect. $$ G $$ doesn't contain a directed cycle, and yet, it doesn't have a unique shortest path; thus, option 3 is incorrect. Now observe that two sums of distinct powers of two cannot be the same (imagine the numbers are written in binary); thus, option 4 is correct, and option 2 is incorrect.

> Consider a directed graph $$ G $$ and a source vertex $$ s $$. Suppose $$ G $$ has some negative edge lengths but no negative cycles, meaning $$ G $$ does not have a directed cycle in which the sum of the edge lengths is negative. Suppose you run Dijkstra's algorithm on $$ G $$ (with source $$ s $$). Which of the following statements are true? [Check all that apply.]
* It's impossible to run Dijkstra's algorithm on a graph with negative edge lengths.
* Dijkstra's algorithm always terminates, but in some cases the paths it computes will not be the shortest paths from $$ s $$ to all other vertices.
* Dijkstra's algorithm might loop forever.
* Dijkstra's algorithm always terminates, and in some cases the paths it computes will be the correct shortest paths from $$ s $$ to all other vertices.

**ANSWER:** Nothing about the description of the algorithm itself relies on there being no negative cycle. Thus, option 1 is incorrect.

Nonnegativity of the edge lengths was used in the correctness proof for Dijkstra's algorithm; with negative edge lengths, the algorithm is no longer correct in general. Thus, option 2 is correct.

The algorithm always halts after $$ n - 1 $$ iterations, where $$ n $$ is the number of vertices. Thus, option 3 is incorrect.

Option 4 is correct; imagine adding a large postive constant $$ M $$ to all the edges. Depending on the edges on a path, this may beef up some paths more than the others, and thus not preserve the shortest path. Consider the graph $$ s \xrightarrow{1} v, v \xrightarrow{-5} t, s \xrightarrow{-2} t $$. The shortest path is $$ s \rightarrow v \rightarrow t $$. We must add at least $$ -5 $$ to make all edge weights non-negative; that gives us the new graph $$ s \xrightarrow{6} v, v \xrightarrow{0} t, s \xrightarrow{3} t $$. Now $$ s \rightarrow v \rightarrow t $$ is no longer the shortest path between $$ v $$ and $$ t $$.

> Consider a directed graph $$ G $$ and a source vertex $$ s $$. Suppose $$ G $$ contains a negative cycle (a directed cycle in which the sum of the edge lengths is negative) and also a path from $$ s $$ to this cycle. Suppose you run Dijkstra's algorithm on $$ G $$ (with source $$ s $$). Which of the following statements are true? [Check all that apply.]
* It's impossible to run Dijkstra's algorithm on a graph with negative edge lengths.
* Dijkstra's algorithm might loop forever.
* Dijkstra's algorithm always terminates, but in some cases the paths it computes will not be the shortest paths from $$ s $$ to all other vertices.
* Dijkstra's algorithm always terminates, and in some cases the paths it computes will be the correct shortest paths from $$ s $$ to all other vertices.

**ANSWER:** Nothing about the description of the algorithm itself relies on there being no negative cycle. Thus, option 1 is incorrect.

When there is negative cycle reachable from $$ s $$, there is no shortest path from $$ s $$ to any vertex on cycle (every path can be made shorter by going around the cycle an additional time). Thus, option 2 is correct.

Options 3 and 4 are incorrect because they are contracdictory to option 2.