---
title: "Homework 5 Optional Problems"
excerpt: "Answers to Homework 5 Optional Problems from Algorithms Design and Analysis II Course."
mathjax: true
---
> Consider an undirected graph $$ G = (V,E) $$ with nonnegative edge costs. You are given a set $$ T \subseteq V $$ of $$ k $$ vertices called terminals. A Steiner tree is a subset $$ F \subseteq E $$ of edges that contains a path between each pair of terminals. For example, if $$ T = V $$, then the Steiner trees are the same as the connected subgraphs. It is a fact that the decision version of the Steiner tree problem is NP-complete. Give a dynamic programming algorithm for this problem (i.e., for computing a Steiner tree with the fewest number of edges) that has running time of the form $$ O(c^k \cdot poly(n)) $$, where $$ c $$ is a constant (like 4) and poly is some polynomial function.

**ANSWER:** Dreyfus-Wagner’s algorithm can compute a Steiner tree in $$ O(3^kn^2) $$ time. See [this](/assets/docs/algorithms-curated/Efficient algorithms for Steiner Tree Problem - Meng.pdf) paper.
