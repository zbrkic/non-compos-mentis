---
title: "Problem Set 3"
excerpt: "Answers to Problem Set 3 from Algorithms Design and Analysis Course."
mathjax: true
---
> How many different minimum cuts are there in a tree with $$ n $$ nodes (ie. $$ n - 1 $$ edges)?
  * \\(n - 1\\)
  * \\(2^n - 2\\)
  * \\(\binom{n}{k}\\)
  * \\(n\\)

**ANSWER:** $$ n - 1 $$, since every edge represents a distinct minimum cut (with one crossing edge). Option 1 is correct.

> Let "output" denote the cut output by Karger's min cut algorithm on a given connected graph with $$ n $$ vertices, and let $$ p = \frac{1}{\binom{n}{k}} $$, Which of the following statements are true?
* For every graph $$ G $$ with $$ n $$ nodes, there exists a min cut $$ (A,B) $$ of $$ G $$ such that $$ Pr[out = (A,B)] \geq p $$
* There exists a graph $$ G $$ with $$ n $$ nodes and a min cut $$ (A,B) $$ of $$ G $$ such that $$ Pr[out = (A,B)] \leq p $$
* For every graph $$ G $$ with $$ n $$ nodes and every min cut $$ (A,B) $$ of $$ G $$, $$ Pr[out = (A,B)] \geq p $$
* For every graph $$ G $$ with $$ n $$ nodes, there exists a min cut $$ (A,B) $$ of $$ G $$ such that $$ Pr[out = (A,B)] \leq p $$
* For every graph $$ G $$ with $$ n $$ nodes and every min cut $$ (A,B) $$ of $$ G $$, $$ Pr[out = (A,B)] \leq p $$

**ANSWER:** We know that the probability of finding a certain min cut is lower bounded by $$ p $$, so options 1 and 3 are true. What is non-trivial is that whether or not there exists a graph and a min cut such that the probability of finding it is at most $$ p $$. This is, in fact, possible, for example, a graph with only two nodes and one edge. The probability of finding the min cut is $$ 1 $$ and that is also the same value for $$ p $$. Therefore option 2 is also correct.

> Let $$ .5 < \alpha < 1 $$ be some constant. Suppose you are looking for the median element in an array using RANDOMIZED SELECT (as explained in lectures). What is the probability that after the first iteration the size of the subarray in which the element you are looking for lies is ≤ ⍺ times the size of the original array?
* \\(\alpha - \frac{1}{2}\\)
* \\(1 - \alpha\\)
* \\(2\alpha - 1\\)
* \\(1 - \frac{\alpha}{2}\\)

**ANSWER:** Clearly, if the chosen pivot is $$ \geq \alpha $$, the size of the subarray cannot be $$ \leq \alpha $$. Therefore, we have an upper bound on the choice of the pivot, $$ \alpha $$. By symmetry, we must have a lower bound on the choice of pivot, otherwise, the size of the subarray cannot be $$ \leq \alpha $$. For example, if $$ \alpha = .7 $$, and $$ n = 10 $$, in order for the size of the subarray $$ \leq \alpha $$, the pivot cannot be the greater than the 7th element, or smaller than the 3rd element. The probability of both of these cases is $$ 1 - \alpha $$; therefore, the probability of none of these cases is $$ 1 - 2 * (1 - \alpha) = 2\alpha - 1 $$. Option 3 is correct.

> Let $$ 0 < \alpha < 1 $$ be a constant, independent of $$ n $$. Consider an execution of RSelect in which you always manage to throw out at least a $$ 1 - \alpha $$ fraction of the remaining elements before you recurse. What is the maximum number of recursive calls you'll make before terminating?
* \\(-\frac{\log n}{log(1 - \alpha)}\\)
* \\(-\frac{\log n}{ \alpha}\\)
* \\(-\frac{\log n}{log \frac{1}{2} + \alpha}\\)
* \\(-\frac{\log n}{log \alpha}\\)

**ANSWER:** Let $$ h $$ be the height of the recursion tree, $$ n * \alpha^h = 1 $$. Therefore, $$ h = \log_\alpha(n) = -log n/log \alpha $$. Option 4 is correct.

> The minimum s-t cut problem is the following. The input is an undirected graph, and two distinct vertices of the graph are labelled "s" and "t". The goal is to compute the minimum cut (i.e., fewest number of crossing edges) that satisfies the property that s and t are on different sides of the cut.
>
> Suppose someone gives you a subroutine for this s-t minimum cut problem via an API. Your job is to solve the original minimum cut problem (the one discussed in the lectures), when all you can do is invoke the given min s-t cut subroutine. (That is, the goal is to reduce the min cut problem to the min s-t cut problem.)
>
> Now suppose you are given an instance of the minimum cut problem -- that is, you are given an undirected graph (with no specially labelled vertices) and need to compute the minimum cut. What is the minimum number of times that you need to call the given min s-t cut subroutine to guarantee that you'll find a min cut of the given graph?
* \\(n - 1\\)
* \\(n\\)
* \\(\frac{n}{2}\\)
* \\(2^n\\)

**ANSWER:** Fix $$ s $$ to be one of the vertex and vary $$ t $$ across all others, then we are done by picking the smallest cut, therefore, we need at most $$ n − 1 $$ call. Option 1 is correct.
