---
title: "Homework 4 Optional Problems"
excerpt: "Answers to Homework 4 Optional Problems from Algorithms Design and Analysis Course."
mathjax: true
---
> In the 2SAT problem, you are given a set of clauses, where each clause is the disjunction of two literals (a literal is a Boolean variable or the negation of a Boolean variable). You are looking for a way to assign a value "true" or "false" to each of the variables so that all clauses are satisfied --- that is, there is at least one true literal in each clause. For this problem, design an algorithm that determines whether or not a given 2SAT instance has a satisfying assignment. (Your algorithm does not need to exhibit a satisfying assignment, just decide whether or not one exists.) Your algorithm should run in $$ O(m + n) $$ time, where $$ m $$ and $$ n $$ are the number of clauses and variables, respectively. [Hint: strongly connected components.]

**ANSWER:** Quoting [Wikipedia](https://en.wikipedia.org/wiki/2-satisfiability):
> In computer science, 2-satisfiability, 2-SAT or just 2SAT is a computational problem of assigning values to variables, each of which has two possible values, in order to satisfy a system of constraints on pairs of variables. It is a special case of the general Boolean satisfiability problem, which can involve constraints on more than two variables, and of constraint satisfaction problems, which can allow more than two choices for the value of each variable. But in contrast to those more general problems, which are NP-complete, 2-satisfiability can be solved in polynomial time.

From the given formula, we construct a digraph $$ G $$ where each vertex is a literal and each edge an implication between two literals. Each clause can be equivalently expressed as two implications:
$$ (x \lor y) \equiv (\neg x \implies y) \equiv (\neg y \implies x) $$

The above implications should be intuitive; Given $$ x $$ is $$ false $$ (not $$ true $$), if the clause is to be $$ true $$, $$ y $$ must be $$ true $$ (since the clause is a Boolean OR). Similarly, given $$ y $$ is $$ false $$, $$ x $$ must be $$ true $$. Of course, we can also deduce the same from a truth table.

So, whenever there is a clause $$ (x \lor y) $$ is the formula, we add two edges to $$ G $$ corresponding to the equivalent implications. Then we run [Kosaraju's algorithm](https://en.wikipedia.org/wiki/Kosaraju%27s_algorithm) for finding strongly connected components (SCC). The algorithms runs in $$ O(m + n) $$ time. If a literal and its negation are in the same SCC, there is no possible assignment that can make both $$ true $$, thus, the formula is not satisfiable. We need to do a linear scan of each SCC to see if a literal and its negation are both in it; this can be done in $$ O(m + n) $$ time. Thus, the overall time complexity for determining satisfiability is $$ O(m + n) $$.

Having determined satisfiability, we can go further and find assignments that satisfy the formula. In order to do that, we take advantage of a property of Kosaraju’s algorithm: the SCCs are returned in topological order. That is, if a node $$ u $$ is in the ith SCC, $$ v $$ is in the jth one, with $$ i < j $$, $$ u $$ appears before $$ v $$.

That tells us that, if we take those $$ x $$ and $$ \neg x $$, the original formula can have the implication $$ x \implies \neg x $$, but not in the other direction, otherwise, they wouldn’t be in separate SCCs.

Following the truth table for the implication operation, we want to avoid the case where $$ true \implies false $$; the only case where the implication evaluates to $$ false $$.

Therefore, if $$ x $$ comes before $$ \neg x $$, we choose $$ x = false $$, thus making $$ (x \implies \neg x) = true $$. On the other hand, if $$ \neg x $$ comes before $$ x $$, we choose $$ x = true $$, thus making $$ (\neg x \implies x) = true $$.
