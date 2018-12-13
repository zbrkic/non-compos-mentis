---
title: "Problem Set 6"
excerpt: "Answers to Problem Set 6 from Algorithms Design and Analysis Course."
mathjax: true
---
> Suppose we use a hash function $$ h $$ to hash $$ n $$ distinct keys into an array $$ T $$ of length $$ m $$. Assuming simple uniform hashing --- that is, with each key mapped independently and uniformly to a random bucket --- what is the expected number of keys that get mapped to the first bucket? More precisely, what is the expected cardinality of the set $$ \{ k : h(k) = 1 \} $$.
* \\(\frac{1}{m}\\)
* \\(\frac{1}{n}\\)
* \\(\frac{m}{2n}\\)
* \\(\frac{n}{2m}\\)
* \\(\frac{m}{n}\\)
* \\(\frac{n}{m}\\)

**ANSWER:** Let $$ X{i} $$ be a random variable that represents key $$ i $$ hashing to the first bucket.

$$
\begin{equation*}
\begin{aligned}
  X{i} & = Pr[\text{key i hashing to the first bucket}] \\
   & = \frac{1}{m} \text{ (since all m locations are equally likely)}
\end{aligned}
\end{equation*}
$$

Taking Expectation on both sides

$$
\begin{equation*}
\begin{aligned}
  E[X] & = \sum_{i=1}^{n} \frac{1}{m} \\
    & = \frac{n}{m}
\end{aligned}
\end{equation*}
$$

Therefore, option 6 is correct.

> You are given a binary tree (via a pointer to its root) with $$ n $$ nodes, which may or may not be a binary search tree. How much time is necessary and sufficient to check whether or not the tree satisfies the search tree property?
* \\(height\\)
* \\(n\log n\\)
* \\(\log n\\)
* \\(n\\)

**ANSWER:** Option 4 is correct. For the lower bound, if there is a violation of the search tree property, we might need to examine all of the nodes to find it (in the worst case).
For the upper bound, we can determine search tree property by looking at all of the nodes.

> You are given a binary tree (via a pointer to its root) with $$ n $$ nodes. As in lecture, let size(x) denote the number of nodes in the subtree rooted at the node x.
>
> How much time is necessary and sufficient to compute size(x) for every node x of the tree?
* \\(height\\)
* \\(n^2\\)
* \\(n\log n\\)
* \\(n\\)

**ANSWER:** Option 4 is correct. For the lower bound, note that a linear number of quantities need to be computed. For the upper bound, recursively compute the sizes of the left and right subtrees, and use the formula size(x) = 1 + size(y) + size(z) from lecture.

> Which of the following is not a property that you expect a well-designed hash function to have?
* The hash function should "spread out" every data set (across the buckets/slots of the hash table).
* The hash function should "spread out" most (i.e., "non-pathological") data sets (across the buckets/slots of the hash table).
* The hash function should be easy to store (constant space or close to it).
* The hash function should be easy to compute (constant time or close to it).

**ANSWER:** Options 2, 3, and 4 are desirable properties of a good hash function. We can wish for option 1, but no known hash function has achieved it; thus, it is practically _not_ expected of a well-designed hash function.

> Suppose we relax the third invariant of red-black trees to the property that there are no three reds in a row. That is, if a node and its parent are both red, then both of its children must be black. Call these relaxed red-black trees. Which of the following statements is not true?
* Every red-black tree is also a relaxed red-black tree.
* The height of every relaxed red-black tree with $$ n $$ nodes is $$ O(\log n) $$.
* There is a relaxed red-black tree that is not also a red-black tree.
* Every binary search tree can be turned into a relaxed red-black tree (via some coloring of the nodes as black or red).

**ANSWER:** Option 1 is correct by definition.

Video leature 13.4 proves that in a red-black tree with $$ n $$ nodes, there is a root-NULL path with at most $$ \log_2(n + 1) $$ black nodes, and thus at most $$ 2\log_2(n + 1) $$ total nodes. Since a relaxed red-black tree may contain two red nodes for every black node, the total number of nodes from a root-NULL path is at most $$ 3\log_2(n + 1) $$. Thus, the height is $$ O(\log n) $$, and therefore, option 2 is correct.

Option 3 is correct simply because a regular red-black tree doesn't allow two red nodes in a row, but the relaxed one does. So, any relaxed red-black tree with two red nodes in a row is _not_ a regular red-black tree.

Option 4 is incorrect. Consider the following BST:
```
 1
  \
   2
     \
      3
        \
         4
```

It can't be turned into a relaxed red-black tree simply by coloring, because no matter how we color the nodes, invariant four is violated that all root-NULL paths must have the same number of black nodes. Obviously, the path $$ 1 - NULL $$ (going left from the root) has only one black node, namely the root itself ($$ 1 $$), but there are at least two black nodes in the path $$ 1 - 4 $$.

> Suppose we use a hash function $$ h $$ to hash $$ n $$ distinct keys into an array $$ T $$ of length $$ m $$. Say that two distinct keys $$ x,y $$ collide under $$ h $$ if $$ h(x) = h(y) $$. Assuming simple uniform hashing --- that is, with each key mapped independently and uniformly to a random bucket --- what is the probability that a given pair $$ x,y $$ of distinct keys collide?
* \\(\frac{1}{m - 1}\\)
* \\(\frac{1}{m}\\)
* \\(\frac{1}{n^2}\\)
* \\(\frac{1}{m^2}\\)
* \\(\frac{1}{n}\\)

**ANSWER:** Since hashing of the keys are independent events, therefore, the probability of a given pair of distinct keys hashing to the same bucket is simply $$ \frac{1}{m} * \frac{1}{m} $$. Since all buckets are equally likely, the probability of a given pair of distinct keys hashing to _any_ bucket is $$ m * \frac{1}{m} * \frac{1}{m}  = \frac{1}{m} $$. Therefore, option 2 is correct.

> Suppose we use a hash function $$ h $$ to hash $$ n $$ distinct keys into an array $$ T $$ of length $$ m $$. Assuming simple uniform hashing --- that is, with each key mapped independently and uniformly to a random bucket --- what is the expected number of pairs of distinct keys that collide? (As above, distinct keys $$ x,y $$ are said to collide if $$ h(x) = h(y) $$.)
* \\(\frac{n}{m^2}\\)
* \\(\frac{n^2}{m}\\)
* \\(\frac{n(n - 1)}{m}\\)
* \\(\frac{n}{m}\\)
* \\(\frac{n(n - 1)}{2m}\\)

**ANSWER:** There are $$ \binom{n}{2} $$ pairs of distinct keys. By the previous problem, each pair has a $$ \frac{1}{m} $$ chance of colliding. Therefore, the expected number of pairs of distinct keys that collide is given by:

$$
\sum_{i=1}^{\binom{n}{2}} \frac{1}{m} = \frac{n(n - 1)}{2m}
$$

Therefore, option 5 is correct.

> To interpret our heuristic analysis of bloom filters in lecture, we considered the case where we were willing to use 8 bits of space per object in the bloom filter. Suppose we were willing to use twice as much space (16 bits per object). What can you say about the corresponding false positive rate, according to our heuristic analysis (assuming that the number $$ k $$ of hash tables is set optimally)? [Choose the strongest true statement.]
* Less than $$ 1\% $$
* Less than $$ .1\% $$
* Less than $$ .01\% $$
* Less than $$ .001\% $$

**ANSWER:** The probabibilty of false positive, $$ \epsilon $$, is approximately $$ (1 - e^{\frac{-k}{b}})^k $$, where $$ b $$ is the number of bits per object and $$ k $$ is the number of hash functions. $$ k $$ is approximated by $$ 0.693 \times b = 11 $$. Plugging that in the formula for $$ \epsilon $$, we get $$ (1 - e^{\frac{-11}{16}})^{11} \approx 0.0004 $$, which is $$ .04\% $$. Therefore, option 2 is correct (option 1 is correct as well, but 2 is a stronger statement).
