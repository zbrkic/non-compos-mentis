---
title: "Problem Set 2"
excerpt: "Answers to Problem Set 2 from Algorithms Design and Analysis Course."
mathjax: true
---
> Suppose the running time of an algorithm is governed by the recurrence $$ T(n) = 7 * T(\frac{n}{3}) + n^2 $$. What's the overall asymptotic running time (i.e., the value of $$ T(n) $$)?
* \\(\Theta(n^{2.81})\\)
* \\(\Theta(n^2)\\)
* \\(\Theta(n^2\log n)\\)
* \\(\Theta(n\log n)\\)

**ANSWER:** Applying the Master Method, $$ a = 7, b = 3, d = 2, a < b^d $$, case 2, work done at the root dominates the running time, therefore, running time is $$ \Theta(n^2) $$. Option 2 is correct.

> Suppose the running time of an algorithm is governed by the recurrence $$ T(n) = 9 * T(\frac{n}{3}) + n^2 $$. What's the overall asymptotic running time (i.e., the value of $$ T(n) $$)?
* \\(\Theta(n^{3.17})\\)
* \\(\Theta(n^2\log n)\\)
* \\(\Theta(n^2)\\)
* \\(\Theta(n\log n)\\)

**ANSWER:** Applying the Master Method, $$ a = 9, b = 3, d = 2, a = b^d $$, work done at every level is the same, case 1, therefore, running time is $$ \Theta(n^2\log n) $$. Option 2 is correct.

> Suppose the running time of an algorithm is governed by the recurrence $$ T(n) = 5 * T(\frac{n}{3}) + 4n $$. What's the overall asymptotic running time (i.e., the value of $$ T(n) $$)?
* \\(\Theta(n^{\frac{\log 3}{\log 5}})\\)
* \\(\Theta(n^{\log_3 5})\\)
* \\(\Theta(n^{\frac{5}{3}})\\)
* \\(\Theta(n^{2.59})\\)
* \\(\Theta(n^2)\\)
* \\(\Theta(n\log n)\\)

**ANSWER:** Applying the Master Method, $$ a = 5, b = 3, d = 1, a > b^d $$, work done = number of leaves, case 3, therefore, running time is $$ \Theta(5^{\log_3 n}) = \Theta(n^{\log_3 5}) $$. Option 2 is correct.

> Consider the following pseudocode for calculating $$ a^b $$ (where $$ a $$ and $$ b $$ are positive integers)
```
FastPower(a,b) :
  if b = 1
    return a
  else
    c := a*a
    ans := FastPower(c,[b/2])
  if b is odd
    return a*ans
  else return ans
end
  ```
  Here $$ [x] $$ denotes the floor function, that is, the largest integer less than or equal to $$ x $$.
>
> Now assuming that you use a calculator that supports multiplication and division (i.e., you can do multiplications and divisions in constant time), what would be the overall asymptotic running time of the above algorithm (as a function of $$ b $$)?
* \\(\Theta(\log b)\\)
* \\(\Theta(\sqrt{b})\\)
* \\(\Theta(b\log b)\\)
* \\(\Theta(b)\\)

**ANSWER:** Outside of recursion, we do constant work; each time, the input size is halved, therefore, $$ a = 1, b = 2, d = 0, a = b^d $$, case 2 of Master Method gives $$ O(n^d \log n) = O(\log n) = \Theta(\log b) $$ (input size is $$ b $$ here). Option 1 is correct.

> Choose the smallest correct upper bound on the solution to the following recurrence: $$ T(1) = 1 $$ and $$ T(n) < T(\lfloor \sqrt{n} \rfloor) + 1 $$ for $$ n > 1 $$. (Note that the Master Method does not apply.)
* \\(O(\log n)\\)
* \\(O(\log{\log n})\\)
* \\(O(1)\\)
* \\(O(\sqrt{n})\\)

**ANSWER:** Substitute $$ m = \log n $$ or $$ n = 2^m $$, and $$ S(m) = T(2^m) $$

$$ T(2^m) < T(2^\frac{m}{2}) + 1 $$ \\
$$ \therefore S(m) < S(\frac{m}{2}) + 1 $$ (If this is unclear, let $$ k = \frac{m}{2} $$ and notice all we are doing is $$ S(k) = T(2^k) $$) \\
$$ \leq S(\frac{m}{2}) + 1 $$ \\
$$ a = 1, b = 2, d = 0, a = b^d $$, Master Method case 1, $$ O(\log m) = O(\log{\log n}) $$. Option 2 is correct.
