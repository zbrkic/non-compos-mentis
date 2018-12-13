---
title: "Homework 3 Optional Problems"
excerpt: "Answers to Homework 3 Optional Problems from Algorithms Design and Analysis Course."
mathjax: true
---
> Prove that the worst-case expected running time of every randomized comparison-based sorting algorithm is $$ \Omega(n\log n) $$. (Here the worst-case is over inputs, and the expectation is over the random coin flips made by the algorithm.)?

**ANSWER:** TBD

> Suppose we modify the deterministic linear-time selection algorithm by grouping the elements into groups of 7, rather than groups of 5. (Use the "median-of-medians" as the pivot, as before.) Does the algorithm still run in $$ O(n) $$ time? What if we use groups of 3?

**ANSWER:** The median for odd number of elements is the middle element, for even number it's the first of 2 middle elements. For example, the median of 5 elements is the 3rd element, and it's also the 3rd for 6 elements. Therefore, the median is the $$ \lceil \frac{k}{2} \rceil $$ element for all $$ k \geq $$ 1. Consider the following array:
```
x x x x x x
x x x x x x x
x x x X x x x
x x x x x x x
x x x x x x
```
$$ n = 32, m = 5, k = \lceil \frac{n}{m} \rceil = 7, \lceil k/2 \rceil = 4, \\
	\text{number of elements} > X = 8, \text{number of elements} < X = 11 $$

At least half of the $$ \lceil \frac{n}{5} \rceil $$ groups contribute at least $$ 3 $$ elements that are greater than $$ X $$, except for the one group that has fewer than $$ 5 $$ elements if $$ 5 $$ does not divide $$ n $$ exactly, and the one group containing $$ X $$ itself. Discounting these two groups, it follows that the number of elements greater than $$ X $$ is at least $$ 3(\lceil \frac{1}{2}\lceil \frac{n}{5} \rceil \rceil - 2) $$. It follows from the definition of ceiling that this expression $$ \geq \frac{3n}{10} - 6 $$.
Similarly, at least $$ \frac{3n}{10} - 6 $$ elements are smaller than $$ X $$. Thus, in the worst case, the size of the subarray in the recursive SELECT call is $$ (n - (\frac{3n}{10} - 6)) = \frac{7n}{10} + 6 $$.

Therefore, the recurrence relation is:
$$
\begin{equation*}
\begin{aligned}
  T(n) & \leq T(\lceil \frac{n}{5} \rceil) + T(\frac{7n}{10} + 6) + O(n) \\
   & \leq T(\frac{n}{5}) + T(\frac{7n}{10} + 6) + O(n)
\end{aligned}
\end{equation*}
$$

This recurrence is one of the following generic form:
$$ T(n) \leq \sum_{i=1}^k T(a_{i}n) + O(n), where \sum_{i=1}^k a_i \leq 1 $$

The solution to the above is given by:
$$
T(n) = \begin{cases}
  O(n) & \text{if } \sum_{i=1}^k a_{i} < 1 \\
  O(n\log n) & \text{if } \sum_{i=1}^k a_i = 1
\end{cases}
$$

Since $$ \frac{1}{5} + \frac{7}{10} = \frac{9}{10} < 1, T(n) = O(n) $$

Similarly, for $$ m = 7 $$, the number of elements greater than $$ X $$ is at least:
$$ 4(\lceil \frac{1}{2}\lceil \frac{n}{7} \rceil \rceil - 3) \geq \frac{2n}{7} - 8 $$

Therefore, the recurrence relation is
$$ T(n) \leq T(\frac{n}{7}) + T(\frac{5n}{7} + 8) + O(n) $$

Since $$ \frac{1}{7} + \frac{5}{7} = \frac{6}{7} < 1, T(n) = O(n) $$

For $$ m = 3 $$, the number of elements greater than $$ X $$ is at least:
$$ 2(\lceil \frac{1}{2}\lceil \frac{n}{3} \rceil \rceil - 2) \geq \frac{n}{3} - 4 $$

Therefore, the recurrence relation is
$$ T(n) \leq T(\frac{n}{3}) + T(\frac{2n}{3} + 4) + O(n) $$

Since $$ \frac{1}{3} + \frac{2}{3} = 1, T(n) = O(n\log n) $$

> Given an array of n distinct (but unsorted) elements $$ x_1, x_2,...,x_n $$ with $$ w_1, w_2,...,w_n $$ such that $$ \sum_{i=1}^k w_i = W $$, a weighted median is an element $$ x_k $$ for which the total weight of all elements with value less than $$ x_k $$ is at most $$ \frac{W}{2} $$, and also the total weight of elements with value larger than $$ x_k $$ is at most $$ \frac{W}{2} $$. Observe that there are at most two weighted medians. Show how to compute all weighted medians in $$ O(n) $$ worst-case time.

**ANSWER:** The weighted-median algorithm works as follows. If $$ n \leq 2 $$, we just return the brute-force solution. Otherwise, we proceed as follows (the pseudocode handles the special case of two medians, this description only applies to finding the lower/only weighted median).
We find the actual median $$ x_k $$ of the n elements and then partition around it. Then compute the total weights of the two halves. If the weights of the two halves are each $$ \leq \frac{W}{2} $$, then the weighted median is $$ x_k $$. Otherwise, the weighted (lower) median should be in the half with total weight exceeding $$ \frac{W}{2} $$. The total weight of the "lighter" half is added to the weight of $$ x_k $$, and the search continues with the heavier half.
```
WEIGHTED-MEDIAN(x, w, n)
if n == 1
    return x[1]
else if n == 2
    // lower and upper weighted medians
    if w[1] == w[2]
        return {x[1], x[2]}
    else if w[1] < w[2]
        return {x[2]}
    else
        return {x[1]}
else
    // using randomized linear-time selection
    find the median x[k] of X = {x[1], x[2], ..., x[n]}
    // using the O(n) partition algorithm from QuickSort
    partition the set X around x[k]
    // using linear scan
    compute W[L] = sum(x[i] < x[k]) w[i]
    	and W[R] = sum(x[i] > x[k]) w[i]
    // x[k] = lower weighted median
    if W[L] < W/2 and W[R] == W/2      // (1)
        return {x[k], x[k + 1]}
    // x[k] = upper weighted median
    else if W[L] == W/2 and W[R] < W/2 // (2)
        return {x[k - 1], x[k]}
     // x[k] = weighted median
    else if W[L] ≤ W/2 and W[R] ≤ W/2  // (3)
        return {x[k]}
    // by definition of weighted median,
    // it must be on the heavier side
    else if W[L] > W/2                 // (4)
        w[k] = w[k] + W[R]
        X' = {x[i] ∈ X: x[i] ≤ x[k]}
        return WEIGHTED-MEDIAN(X')
    else                               // (5)
        w[k] = w[k] + W[L]
        X' = {x[i] ∈ X: x[i] ≥ x[k]}
        return WEIGHTED-MEDIAN(X')
```

Example 1:
```
x = {1, 2, 3, 4, 5}, w = {.15, .1, .2, .3, .25}, n = 5
W = 1, W/2 = .5
Iteration 1:
    k = 3, x[3] = 3, w[3] = .2, W[L] = .25, W[R] = .55
    Case 5
    recurse with x = {3, 4, 5}, w = {.45, .3, .25}, n = 3
Iteration 2:
    k = 2, x[2] = 4, w[2] = .3, W[L] = .45, W[R] = .25
    Case 3
    return {4}
```
Example 2:
```
x = {1, 2, 3, 4}, w = {.49, .01, .25, .25}, n = 4
W = 1, W/2 = .5
Iteration 1:
    k = 2, x[2] = 2, w[2] = .01, W[L] = .49, W[R] = .50
    Case 1
    return {2, 3}
```

> We showed in an optional video lecture that every undirected graph has only polynomially (in the number n of vertices) different minimum cuts. Is this also true for directed graphs? Prove it or give a counterexample.

**ANSWER:** TBD

> For a parameter $$ \alpha \geq 1 $$, an $$ \alpha $$-minimum cut is one for which the number of crossing edges is at most $$ \alpha $$ times that of a minimum cut. How many $$ \alpha $$-minimum cuts can an undirected graph have, as a function of $$ \alpha $$ and the number $$ n $$ of vertices? Prove the best upper bound that you can.

**ANSWER:** $$ n^{2\alpha} $$. Proof TBD.