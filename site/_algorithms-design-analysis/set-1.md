---
title: "Problem Set 1"
excerpt: "Answers to Problem Set 1 from Algorithms Design and Analysis Course."
mathjax: true
---
> 3-way-Merge Sort. Suppose that instead of dividing in half at each step of Merge Sort, you divide into thirds, sort each third, and finally combine all of them using a three-way merge subroutine. What is the overall asymptotic running time of this algorithm? (Hint: Note that the merge step can still be implemented in $$ O(n) $$ time.)
* \\(n(\log n)^2\\)
* \\(n\\)
* \\(n\log n\\)
* \\(n^2\log n\\)

**ANSWER:** It follows that the height of the recursion tree is $$ \log_{3} n $$. Thus, overall running time is $$ n\log_{3} n $$; option 3 is correct.

> You are given functions $$ f $$ and $$ g $$ such that $$ f(n) = O(g(n)) $$. Is $$ f(n) * \log f(n)^c = O(g(n) * \log g(n)) $$?
(Here $$ c $$ is some positive constant.) You should assume that $$ f $$ and $$ g $$ are nondecreasing and always bigger than 1.
* Sometimes yes, sometimes no, depending on the functions $$ f $$ and $$ g $$
* Sometimes yes, sometimes no, depending on the constant $$ c $$
* False
* True

**ANSWER:** Let $$ x = f(n) * \log f(n)^c $$

Substituting the inequality $$ f(n) \leq c'g(n) $$ by definition of Big-Oh, and the min value of $$ c = 1 $$
$$
\begin{equation*}
\begin{aligned}
  x & \leq c' * g(n) * \log(c' * g(n)) \\
   & \leq c' * g(n) * (\log c' + \log g(n)) \\
   & \leq g(n) * \log g(n) \text{ choosing } c' = 1
\end{aligned}
\tag{*}
\end{equation*}
$$

The expression $$ (*) $$ is precisely the definition of Big-Oh; therefore, option 4 is correct.

> Assume again two (positive) nondecreasing functions $$ f $$ and $$ g $$ such that $$ f(n) = O(g(n)) $$. Is $$ 2^{f(n)} = O(2^{g(n)}) $$?
(Multiple answers may be correct, you should check all of those that apply.)
* Yes if $$ f(n) \leq g(n) $$ for all sufficiently large $$ n$$
* Never
* Sometimes yes, sometimes no (depending on the $$ f $$ and $$ g $$)
* Always

**ANSWER:**

$$
\begin{equation}
\begin{aligned}
  f(n) & = O(g(n)) \nonumber \\
   & \leq cg(n) \quad \exists n_0, c \geq 1, \forall n \geq n_0
\end{aligned}
\tag{*}
\end{equation}
$$

Raising both sides to the power of 2, since $$ f $$ and $$ g $$ are positive increasing functions

$$ 2^{f(n)} ≤ c2^{g(n)} \tag{**} $$

The expression $$ (**) $$ looks like it fits the bill for Big-Oh, but remember that expression $$ (*) $$ holds only for some large enough $$ n_{0} $$.
Therefore, option 1 is correct for all $$ n \geq n_{0} $$. For $$ n < n_{0} $$, we don't really know, so option 3 is also correct.

> k-way-Merge Sort. Suppose you are given $$ k $$ sorted arrays, each with $$ n $$ elements, and you want to combine them into a single array of $$ kn $$ elements. Consider the following approach. Using the merge subroutine taught in lecture, you merge the first $$ 2 $$ arrays, then merge the $$ 3^{rd} $$ given array with this merged version of the first two arrays, then merge the $$ 4^{th} $$ given array with the merged version of the first three arrays, and so on until you merge in the final ($$ k^{th} $$) input array. What is the running time taken by this successive merging algorithm, as a function of $$ k $$ and $$ n $$?
(Optional: can you think of a faster way to do the k-way merge procedure?)
* \\(\Theta(n\log k)\\)
* \\(\Theta(n^2k)\\)
* \\(\Theta(nk^2)\\)
* \\(\Theta(nk)\\)

**ANSWER:** Merging two sorted arrays with $$ n1 $$ and $$ n2 $$ elements, respectively, takes $$ O(n1 + n2) $$ time. This strategy begins by merging two arrays of size $$ n $$ to create an array of size $$ 2n $$. It then merges that with an array of size $$ n $$, and so on. Thus, the running time $$ T $$ is

$$
\begin{equation*}
\begin{aligned}
  T & = (n + n) + (2n + n) + (3n + n) + ... + (k − 1)n + n \\
   & = (1 + 2 + 3 + ... + (k - 1))n + (k - 1)n \\
   & = \frac{k(k-1)n}{2} + (k - 1)n \\
   & = (k - 1)(\frac{k}{2} + 1)n \\
   & = \Theta(nk^2)
\end{aligned}
\end{equation*}
$$

We can improve the running time by observing that the input is exactly the same as we see in the last level of the Merge Sort recursion tree (assuming the input array breaks up evenly into halves). Therefore, if we merge pairwise, we get the same running time as for Merge Sort, which is $$ O(n\log n) $$ for an input array of size $$ n $$; Since the total number of elements in the given problem is $$ nk $$, we get $$ O(nk\log nk) $$.

> Arrange the following functions in increasing order of growth rate (with $$ g(n) $$ following $$ f(n) $$ in your list if and only if $$ f(n) = O(g(n)) $$.
* \\(n^2\log n\\)
* \\(2^n\\)
* \\(2^{2^n}\\)
* \\(n^{\log n}\\)
* \\(n^2\\)

> Write your 5-letter answer, i.e., the sequence in lower case letters in the space provided. For example, if you feel that the answer is a->b->c->d->e (from smallest to largest), then type abcde in the space provided without any spaces before / after / in between the string.

> You can assume that all logarithms are base 2 (though it actually doesn't matter).

**ANSWER:** eadbc (plot them).
