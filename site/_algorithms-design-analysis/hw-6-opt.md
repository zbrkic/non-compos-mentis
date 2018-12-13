---
title: "Homework 6 Optional Problems"
excerpt: "Answers to Homework 6 Optional Problems from Algorithms Design and Analysis Course."
mathjax: true
---
> Recall that a set $$ H $$ of hash functions (mapping the elements of a universe $$ U $$ to the buckets $$ \{0,1,2,...,n - 1\}) $$ is universal if for every distinct $$ x, y \in U $$, the probability $$ Prob[h(x) = h(y)] $$ that $$ x $$ and $$ y $$ collide, assuming that the hash function $$ h $$ is chosen uniformly at random from $$ H $$, is at most $$ \frac{1}{n} $$. In this problem you will prove that a collision probability of $$ \frac{1}{n} $$ is essentially the best possible. Precisely, suppose that $$ H $$ is a family of hash functions mapping $$ U $$ to $$ \{0,1,2,...,n - 1\} $$, as above. Show that there must be a pair $$ x, y \in U $$ of distinct elements such that, if $$ h $$ is chosen uniformly at random from $$ H $$, then $$ Prob[h(x) = h(y)] \geq \frac{1}{n} - \frac{1}{\lvert U \rvert} $$

**ANSWER:** Let $$ n_i $$ be the size of the set $$ \{x: x \in U, h(x) = i\} $$, for $$ i \in \{0,1,2,...,n - 1\} $$. That is, $$ h_1 $$ maps inputs to bucket 1, $$ h_2 $$ maps inputs to bucket 2, and so on.

* Let us fix a hash function $$ h \in H $$.
* Let $$ N = \lvert U \rvert $$.
* Given $$ n $$ = number of buckets.

Then, the number of distinct $$ x_1, x_2 \in U $$ that collide in bucket 1 is $$ \binom{n_i}{2} $$. The number of distinct $$ x_1, x_2 \in U $$ that collide in all buckets is, therefore, $$ \sum_{i=1}^{n} \binom{n_i}{2} $$ (call this expression $$ L_h $$). Note that $$ n_i \geq 0 \text{ and } \sum_{i=1}^{n} n_i = N $$. We are interested in lower-bounding the expression $$ L_h $$.

$$
\begin{equation*}
\begin{aligned}
  L_h & \geq \sum_{i=1}^{n} \frac{n_i(n_i - 1)}{2} \\
   & = \sum_{i=1}^{n} \frac{n_i^2}{2} - \sum_{i=1}^{n} \frac{n_i}{2} \\
   & = \sum_{i=1}^{n} \frac{n_i^2}{2} - \frac{N}{2}
\end{aligned}
\end{equation*}
$$

It can be shown that the summation is minimized when all $$ n_i $$ are equal, that is, when $$ n_i = \frac{N}{n} $$ [^1] [^2]. Therefore, we get:

$$
\begin{equation*}
\begin{aligned}
  L_h & \geq \frac{1}{2}(\sum_{i=1}^{n} (\frac{N}{n})^2 - N) \\
   & = \frac{N}{2}(\frac{N}{n} - 1)
\end{aligned}
\end{equation*}
$$

Suppose $$ H = \{h_1,h_2,...,h_k\} \text{ and } \vert H \rvert = K $$. Let us define $$ P $$ be the set of all distinct $$ x_1, x_2 \in U $$. Note that $$ \lvert P \rvert = \frac{N(N-1)}{2} $$. Let $$ X_i $$ be an indicator random variable, such that, given a hash function $$ h_i \in H $$ and distinct $$ x_1, x_2 \in U $$:

$$
X_i = \begin{cases}
  1 \text{ if } h_i(x_1) = h_i(x_2) = i \\
  0 \text{ otherwise }
\end{cases}
$$

Taking expectation of $$ X_i $$:

$$
\begin{equation*}
\begin{aligned}
  E[X] & = \sum_{i=1}^{K}\sum_{x,y \in U} Pr[h_i(x_1) = h_i(x_2)] \\
   & = \sum_{x,y \in U} \frac{1}{K}\sum_{i=1}^{K} L_h \\
   & = \frac{1}{\lvert P \rvert} \cdot L_h \\
   & = \frac{2}{N(N-1)} \cdot \frac{N}{2}(\frac{N}{n} - 1) \\
   & \geq \frac{\frac{N}{n} - 1}{N} \\
   & = \frac{1}{n} - \frac{1}{N}
\end{aligned}
\end{equation*}
$$

By the [Pigeon hole Principle](https://en.wikipedia.org/wiki/Pigeonhole_principle), we get: There exists $$ x, y \in U $$ such that the above inequality holds.

## References

[^1]: [Universal Hashing- Minimizing Collisions](/assets/docs/algorithms-curated/Universal Hashing- Minimizing Collisions.pdf)
[^2]: [Universal Classes of Hash Functions](/assets/docs/algorithms-curated/Universal Classes of Hash Functions.pdf)


