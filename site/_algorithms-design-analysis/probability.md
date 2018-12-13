---
title: "Probability Questions"
excerpt: "Answers to Probability Questions."
mathjax: true
---
> Let $$ 0 < \alpha < .5 $$ be some constant (independent of the input array length $$ n $$). Recall the Partition subroutine employed by the QuickSort algorithm, as explained in lecture. What is the probability that, with a randomly chosen pivot element, the Partition subroutine produces a split in which the size of the smaller of the two subarrays is $$ \geq \alpha $$ times the size of the original array?
* \\(1 - 2 * \alpha\\)
* \\(\alpha\\)
* \\(1 - \alpha\\)
* \\(2 - 2 * \alpha\\)

**ANSWER:** If the picked pivot is one of the smallest $$ n\alpha $$ elements in the array, then the left partition's size will be less than $$ n\alpha $$. Similarly, if the picked pivot is one of the largest $$ n\alpha $$ elements in the array, the right partition's size will be less than $$ n\alpha $$.
Hence, there are $$ n - 2 * n\alpha $$ elements that we can pick such that both partitions have size greater than or equal to $$ n\alpha $$. Since the algorithm picks a pivot randomly, all elements have an equal probability of getting picked as the pivot, i.e. $$ \frac{1}{n} $$.
Therefore, $$ Pr = \frac{1}{n}(n - 2n\alpha) = 1 - 2\alpha $$. Option 1 is correct.

> Now assume that you achieve the approximately balanced splits above in every recursive call --- that is, assume that whenever a recursive call is given an array of length $$ k $$, then each of its two recursive calls is passed a subarray with length between $$ k\alpha $$ and $$ k(1 - \alpha) $$ (where $$ \alpha $$ is a fixed constant strictly between $$ 0 $$ and $$ .5 $$). How many recursive calls can occur before you hit the base case? Equivalently, which levels of the recursion tree can contain leaves? Express your answer as a range of possible numbers $$ d $$, from the minimum to the maximum number of recursive calls that might be needed.
* \\(-\frac{\log n}{\log \alpha} \leq d \leq -\frac{\log n}{\log(1 - \alpha)}\\)
* \\(0 \leq d \leq -\frac{\log n}{\log \alpha}\\)
* \\(-\frac{\log n}{\log(1 - \alpha)} \leq d \leq -\frac{\log n}{\log \alpha}\\)
* \\(-\frac{\log n}{\log(1 - 2\alpha)} \leq d \leq -\frac{\log n}{\log(1 - \alpha)}\\)

**ANSWER:** If $$ \alpha < \frac{1}{2} $$, then $$ 1 - \alpha > \alpha $$, thus the branch with subarray length $$ n(1 - \alpha) $$ will have greater recursion depth.

If $$ d $$ is the height of the recursion tree, $$ n(1 - \alpha)^d = 1 $$ \\
Taking $$ log_{1 - \alpha} $$ on both sides
$$ log_{1 - \alpha} n= -d $$ \\
By log rule
$$ d = -\frac{\log n}{\log(1 - \alpha)} $$

The best case is $$ -\frac{\log n}{\log \alpha} $$. Since both $$ \alpha $$ and $$ (1 - \alpha) $$ are less than $$ 1 $$, so, their logarithms are negative. Adding one more negative symbol on that results in an overall positive value for minimum and maximum depth.
Therefore, option 1 is correct.

> Define the recursion depth of QuickSort to be the maximum number of successive recursive calls before it hits the base case --- equivalently, the number of the last level of the corresponding recursion tree. Note that the recursion depth is a random variable, which depends on which pivots get chosen. What is the minimum-possible and maximum-possible recursion depth of QuickSort, respectively?
* \\(Minimum: \Theta(\log n); Maximum: \Theta(n)\\)
* \\(Minimum: \Theta(\log n); Maximum: \Theta(n\log n)\\)
* \\(Minimum: \Theta(1); Maximum: \Theta(n)\\)
* \\(Minimum: \Theta(\sqrt{n}); Maximum: \Theta(n)\\)

**ANSWER:** Option 1 is correct.

> Consider a group of k people. Assume that each person's birthday is drawn uniformly at random from the $$ 365 $$ possibilities. (And ignore leap years.) What is the smallest value of k such that the expected number of pairs of distinct people with the same birthday is at least one?
>
> [Hint: define an indicator random variable for each ordered pair of people. Use linearity of expectation.]
* \\(27\\)
* \\(28\\)
* \\(366\\)
* \\(20\\)
* \\(23\\)

**ANSWER:** For each pair of $$ k $$ people in the room, let $$ X $$ be an indicator random variable such that:
$$
X = \begin{cases}
  1 & \text{if the pair has the same birthday} \\
  0 & \text{otherwise}
\end{cases}
$$

$$
E[X] = \sum_{i=1}^{k-1}\sum_{j=i+1}^{k} X_{ij}Pr[\text{i and j have the same birthday}]
$$
$$ Pr[\text{i and j have unique birthdays}] = 365/365 * 364/365 $$ ($$ i $$ may have been born on any of the $$ 365 $$ days, and $$ j $$ on any of the remaining $$ 364 $$ days).
$$
\therefore Pr[\text{i and j have the same birthday}] = 1 - \frac{364}{365} = \frac{1}{365} \\
\begin{equation*}
\begin{aligned}
  E[X] & = \frac{1}{365} * \sum_{i=1}^{k-1}\sum_{j=i+1}^{k} X_{ij} \\
   & = \frac{1}{365} * \sum_{i=1}^{k-1} (k - i - 1 + 1) \\
   & = \frac{1}{365} * \sum_{i=1}^{k-1} (k - i) \\
   & = \frac{1}{365} * (\sum_{i=1}^{k-1} k - \mathop{\sum_{i=1}^{k-1}} i) \\
   & = \frac{1}{365} * (k(k - 1) - (1 + 2 +...+ k - 1)) \\
   & = \frac{1}{365} * (k(k - 1) - \frac{k(k - 1)}{2}) \\
   & = \frac{k(k - 1)}{(365 * 2)}
\end{aligned}
\end{equation*}
$$

If $$ E[X] = 1, k * (k - 1) = 365 * 2 $$ \\
Rewriting as a general quadratic equation $$ ax^2 + bx + c = 0 $$, for which $$ x $$ is given by $$ \frac{-b \pm \sqrt{b^2 - 4ac}}{2a} $$ \\
$$
k^2 -k -730 = 0, a = 1, b = -1, c= -730 \\
\begin{equation*}
\begin{aligned}
  k & = 1 \pm \frac{\sqrt{1 + 2920}}{2} \\
   & = 1 \pm \frac{54.05}{2} \\
   & = 1 \pm 27.02
\end{aligned}
\end{equation*}
$$

Since the number of people cannot be negative, $$ k \approx 28 $$. Option 2 is correct.

> Let $$ X{1}, X{2}, X{3} $$ denote the outcomes of three rolls of a six-sided die. (i.e., each $$ X{i} $$ is uniformly distributed among $$ 1,2,3,4,5,6 $$, and by assumption they are independent.) Let $$ Y $$ denote the product of $$ X{1} \text{ and } X{2} $$ and $$ Z $$ the product of $$ X{1} \text{ and } X{3} $$. Which of the following statements is correct?
* Y and Z are independent, but $$ E[YZ] \neq E[Y]*E[Z] $$
* Y and Z are not independent, but $$ E[YZ] = E[Y]*E[Z] $$
* Y and Z are not independent, but $$ E[YZ] \neq E[Y]*E[Z] $$
* Y and Z are independent, but $$ E[YZ] \neq E[Y]*E[Z] $$

**ANSWER:** For $$ Y $$ and $$ Z $$ to be independent, by definition, the two events $$ [Y = x1] $$ and $$ [Z = x2] $$ must be independent $$ \forall \text{ x1, x2} $$. If we choose $$ x1 = x2 = 1 $$, then $$ Pr[Y = 1 \text{ AND } Z = 1] $$ is the probability that the outcome of all three rolls was one. Since each roll is independent, this is equal to \\({\frac{1}{6}}^3\\).
$$
Pr[Y = 1]Pr[Z = 1] = \frac{1}{36} * \frac{1}{36} = {\frac{1}{6}}^4
$$

Clearly, $$ Pr[Y = 1 \text{ AND } Z = 1] \neq Pr[Y = 1] * Pr[Z = 1] $$, therefore, $$ Y $$ and $$ Z $$ are not independent.

{: .notice}
Covariance reference: [Expectations on the product of two dependent random variables](https://www.physicsforums.com/threads/expectations-on-the-product-of-two-dependent-random-variables.276125)

$$
\begin{equation*}
\begin{aligned}
  Cov[X,Y] &= E[(X - E[X]) \cdot (Y − E[Y])] \\
   &= E[X \cdot Y] - E[X \cdot E[Y]] - E[Y \cdot E[X]] + E[E[X] \cdot E[Y]] \\
   &= E[X \cdot Y] - E[X] \cdot E[Y] \\
  \therefore E[XY] &= Cov[X,Y] + E[X]E[Y] \\
  E[YZ] &= Cov[Y,Z] + E[Y]E[Z] \text{ (*)} \\
  E[Y] &= \frac{1}{36} * (1 * (1 + 2 +... + 6) + 2 * (1 + 2 + ... + 6) \\
   & + ... + 6 * (1 + 2 + ... + 6)) \\
   &= \frac{1}{36} * (1 + 2 + ... + 6)^2 \\
   &= \frac{1}{36} * 21^2 \\
   &= 12.25
\end{aligned}
\end{equation*}
$$

Clearly, $$ E[Z] $$ is the same.

$$ Cov(Y, Z) = \sum_{i=1}^{6}(y_{i} - E(Y))(z_{i} - E(Z)) $$ \\
$$ y{i} \in \{1*1, 1*2,...,6*1,...,6*6\} $$ and clearly $$ \neq E(Y) $$. Similarly, $$ z_{i} \neq E(Z) $$. Therefore, $$ Cov(Y, Z) \neq 0 $$, and from expression $$ (*), E[YZ] \neq E[Y]E[Z] $$. Option 3 is correct.
