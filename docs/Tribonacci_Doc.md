# **Method: ComputeTrib**

The ComputeTrib method calculates the $n$-th Tribonacci number iteratively. The Tribonacci sequence is similar to the Fibonacci sequence, but each term is the sum of the _three_ previous terms rather than two. The sequence starts with 0, 1, 1\.

This method uses a "sliding window" approach to calculate the value in $O(n)$ time complexity and $O(1)$ space complexity, avoiding the exponential cost of naive recursion.

## **Preconditions**

- **Natural Number Input:** The input n must be a non-negative integer (nat). This implies `n >= 0`.

## **Postconditions**

- **Correctness:** The returned value res is guaranteed to be equal to `Trib(n)`, where Trib is the mathematical function defining the sequence recursively.

## **Loop Invariant**

The loop invariants are critical here to prove that the three variables (a, b, c) correctly represent the "window" of the Tribonacci sequence at any step i.

1. **Counter Range:** The loop counter i is strictly within the range `1 <= i <= n`.
2. **Window Consistency:** The variables a, b, and c always map to specific positions in the sequence relative to i:
   - a represents $T(i-1)$
   - b represents $T(i)$ (This is the value tracked for the final result)
   - c represents $T(i+1)$

By maintaining this window, the algorithm ensures that when the loop terminates `(at i == n)`, the variable b holds the value of $T(n)$.
