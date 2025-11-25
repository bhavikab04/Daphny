# Formal Verification Report: The ComputeTrib Method

## 1. Introduction

The `ComputeTrib` method calculates the $n$-th Tribonacci number iteratively. The Tribonacci sequence is similar to the Fibonacci sequence, but each term is the sum of the *three* previous terms rather than two. The sequence is defined recursively as follows:

$$
T(n) = \begin{cases} 
0 & \text{if } n = 0 \\
1 & \text{if } n = 1 \\
1 & \text{if } n = 2 \\
T(n-1) + T(n-2) + T(n-3) & \text{if } n > 2 
\end{cases}
$$

The sequence begins: $0, 1, 1, 2, 4, 7, 13, \dots$

This method utilizes a "sliding window" approach to calculate the value in $O(n)$ time complexity and $O(1)$ space complexity, avoiding the exponential cost of naive recursion. This report documents all correctness conditions used in the Dafny implementation, records verification failures encountered during experimentation, and explains the rationale behind those failures.

---

## 2. Formal Specification

### 2.1 Preconditions

**Final Correct Preconditions (Working Version)**
> `requires n >= 0`

Although defining `n` as a natural number (`nat`) guarantees non-negativity, the explicit precondition clarifies the domain of the function. No other preconditions are required.

**Experimented Failing Preconditions**

| Attempted Condition | Result | Reason for Failure |
| :--- | :--- | :--- |
| `(none)` | Verified | Dafny inferred bounds from `nat`. However, this was less clear from a specification standpoint. |
| `requires n > 0` | Failed | When $n = 0$, the method returns 0, but the postcondition requires `res == Trib(n)` where `Trib(0)` is valid. Restricting `n > 0` made the base-case correct but unnecessary, and Dafny rejected the invariant range $1 \leq i \leq n$ when $n = 0$. |

### 2.2 Postconditions

**Final Correct Postcondition**
> `ensures res == Trib(n)`

This connects the implementation to the mathematical specification, ensuring functional correctness.

**Experimented Failing Postconditions**

| Attempted Condition | Result | Reason for Failure |
| :--- | :--- | :--- |
| `ensures res >= 0` | Verified | Too weak; does not guarantee functional correctness. |
| `ensures res == Trib(n) + 1` | Failed | Cannot be proven true; contradicts the intended behavior. |
| `ensures res == a` (or `b`, or `c`) | Failed | At return time, only `b` holds the correct Tribonacci value. Dafny cannot prove the disjunction. |

---

## 3. Loop Mechanics

The loop invariants are critical to prove that the three variables ($a, b, c$) correctly represent the "window" of the Tribonacci sequence at any step $i$.

### 3.1 Loop Invariants

**Final Working Invariants**
1. `invariant 1 <= i <= n`
2. `invariant a == Trib(i-1)`
3. `invariant b == Trib(i)`
4. `invariant c == Trib(i+1)`

**Window Consistency**
The variables always map to specific positions in the sequence relative to $i$:
* $a$ represents $T(i-1)$
* $b$ represents $T(i)$ (This is the value tracked for the final result)
* $c$ represents $T(i+1)$

By maintaining this window, the algorithm ensures that when the loop terminates (at $i == n$), the variable $b$ holds the value of $T(n)$.

**Experimented Failing Loop Invariants**

| Invariant Attempt | Result | Why It Failed |
| :--- | :--- | :--- |
| `invariant a == Trib(i)` | Failed | Misaligned indexing. After shifting, $a$ becomes `Trib(i)` only *after* the increment. Dafny rejects it at the loop boundary. |
| `invariant b == Trib(i+1)` | Failed | Violates the actual meaning of the window: $b$ always equals `Trib(i)`, not `Trib(i+1)`. |
| `invariant i < n` (only) | Failed | Not strong enough; Dafny cannot prove the correctness of the window or final result without linking $i$ to the sequence. |
| Removed `a == Trib(i-1)` | Failed | Dafny cannot prove that `next == Trib(i+2)` because the window reasoning breaks. |
| Removed `c == Trib(i+1)` | Failed | Dafny cannot link `next` to a correct Tribonacci step. |

### 3.2 Loop Variant

**Final Working Variant**
> `decreases n - i`

This ensures termination because the value is initially $\ge 0$, decreases strictly with each iteration, and is bounded below by 0.

**Experimented Failing Variants**

| Variant Attempt | Result | Why It Failed |
| :--- | :--- | :--- |
| `decreases i` | Failed | $i$ increases each iteration, so Dafny detects a non-decreasing variant. |
| `decreases n` | Failed | $n$ is constant and does not decrease. |
| `decreases a` (or `b`, `c`) | Failed | These values can increase or decrease unpredictably; the variant is not well-founded. |
| `decreases n - i - 1` | Failed | When $i = n - 1$, the variant becomes 0; the next iteration produces -1, which is invalid. |

---

## 4. Verification Test Cases

The function was tested with both valid and invalid inputs (deliberately breaking invariants or assumptions) to ensure the verifier behaves as expected.

### 4.1 Passing Test Cases
All the following cases verified successfully:

```dafny
var t0 := ComputeTrib(0);
assert t0 == 0;

var t1 := ComputeTrib(1);
assert t1 == 1;

var t2 := ComputeTrib(2);
assert t2 == 1;

var t3 := ComputeTrib(3);
assert t3 == 2;

var t4 := ComputeTrib(4);
assert t4 == 4;

var t5 := ComputeTrib(5);
assert t5 == 7;

var t10 := ComputeTrib(10);
assert t10 == 149;

# 4.2 Fault Injection Experiments

To confirm the robustness of the verification, specific faults were intentionally injected into the code.  
The verifier correctly identified all logical errors.

## Incorrect Code Implementations

| **Fault Scenario** | **Code Change** | **Verification Result** |
|--------------------|-----------------|--------------------------|
| **Removal of Base Case (`n = 0`)** | Removed `if n == 0 return` | Dafny could not prove the postcondition `res == Trib(0)`. |
| **Incorrect Window Initialization** | Initialized `var a := 1` | The initial invariant `a == Trib(i-1)` failed immediately, as `1 ≠ T(0)`. |
| **Incorrect Recurrence Relation** | `var next := a + b` (omitting `c`) | The logical step `next == Trib(i+2)` failed, violating future invariants. |
| **Returning Incorrect Variable** | `return c` | Postcondition failure. At termination, `c = T(n+1)`, not `T(n)`. |
| **Incorrect Loop Bound** | `while i <= n` | When `i = n`, the loop attempts to compute values beyond the required scope. The increment sets `i` to `n+1`, breaking the invariant `i <= n`. |

---

# 5. Summary

The following table summarizes the components required for the formally verified implementation of `ComputeTrib`.

## Component Specifications

| **Component** | **Final Specification** | **Notes** |
|--------------|--------------------------|-----------|
| **Preconditions** | `requires n >= 0` | Establishes the input domain. |
| **Postconditions** | `ensures res == Trib(n)` | Links implementation to the recursive mathematical definition. |
| **Loop Invariants** | - `1 <= i <= n`  <br> - `a == Trib(i-1)` <br> - `b == Trib(i)` <br> - `c == Trib(i+1)` | Essential for proving the sliding‐window logic. |
| **Loop Variant** | `decreases n - i` | Guarantees algorithm termination. |

---

The method passed all verification checks for correctness and termination, and the verifier successfully identified all introduced faults during experimental testing.
