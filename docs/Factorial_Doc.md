# **Method: Factorial**

The Factorial method iteratively computes the factorial of a non-negative integer n. The correctness of this implementation is verified against a purely mathematical recursive specification (FactorialFunction).

The method avoids recursion in its implementation, utilizing a while loop to accumulate the product, which is often more memory-efficient for large inputs in compiled languages.

## **Preconditions**

- **Natural Number Input:** The input n is constrained to the type nat, meaning it must be a non-negative integer `(n >= 0)`. This is enforced by the type system and the method signature.

## **Postconditions**

- **Verification against Specification:** The returned value f must be exactly equal to the result of the recursive specification `FactorialFunction(n)`. This links the iterative code directly to the mathematical truth of factorials.

## **Loop Invariant**

The loop invariants link the iterative state (variables i and result) to the mathematical definition as the loop progresses.

1. **Range Validity:** The counter i remains within the bounds `0 <= i <= n` throughout the execution.
2. **Accumulation Integrity:** At the start of every iteration, the variable result holds the correct factorial value for the current counter i.
   - `invariant result == FactorialFunction(i)`
   - **Initialization:** When i=0, result is 1 `since (0 != 1)`.
   - **Maintenance:** As i increments, result is updated to result \* i, maintaining the invariant that result equals $i\!$.
   - **Termination:** When the loop finishes, `i == n`. Because the invariant holds, result must equal `FactorialFunction(n)`.

Here we have documented the testing of the iterative `Factorial` method using formal verification components in Dafny. The goal is to demonstrate the purpose of preconditions (`requires`), postconditions (`ensures`), loop invariants (`invariant`), and loop variants (`decreases`) by observing when the verification process succeeds or fails against the logic in the file `DafnyFactorialVerification.dfy`.

## Test 1: Successful Verification (Factorial_Success)

This case represents the correctly verified code. The verifier confirms that the code meets its specification.

| Component | Code | Status | Verification Outcome |
| :--- | :--- | :--- | :--- |
| **Precondition** (`requires`) | `true` | Pass | Input `n` is guaranteed to be a natural number (`nat`). |
| **Postcondition** (`ensures`) | `f == FactorialFunction(n)` | Pass | The verifier confirms that upon termination, the final result `f` is mathematically equal to $n!$. |
| **Loop Invariant** (`invariant`) | `result == FactorialFunction(i)` | Pass | The invariant is successfully proven to be true at initialization, maintained in the loop body, and guarantees the postcondition at termination. |
| **Loop Variant** (`decreases`) | `n - i` | Pass | The value strictly decreases from `n` to `0` with each step, guaranteeing the loop terminates. |

***

## Test 2: Verification Failure Cases

The following test methods contain intentional errors in either the code logic or the formal specification, causing the Dafny verifier to fail and highlight the exact point of contradiction.

### Case A: Failure Due to Incorrect Postcondition (Factorial_Fail_Postcondition)

| Component | Intentional Change | Failure Location | Reason |
| :--- | :--- | :--- | :--- |
| **Postcondition** (`ensures`) | `ensures f == FactorialFunction(n) + 1` | The `ensures` clause | The method computes `f = n!`, but the specification *demands* `f = n! + 1`. The proof that $n! = n! + 1$ fails for all $n \ge 0$. |
| **Dafny Error** | | | *A postcondition will not hold on this return path.* |

### Case B: Failure Due to Incorrect Loop Invariant (Factorial_Fail_Invariant_Init)

| Component | Intentional Change | Failure Location | Reason |
| :--- | :--- | :--- | :--- |
| **Code Initialization** | `var result := 0;` (Should be `1`) | The `invariant result == FactorialFunction(i)` | At the start of the loop, `i=0`. The invariant requires $result = 0! = 1$. The code provides $result = 0$, violating the invariant before the loop begins. |
| **Dafny Error** | | | *Loop invariant will not hold at the beginning of the loop.* |

### Case C: Failure Due to Incorrect Loop Invariant (Factorial_Fail_Invariant_Maintenance)

| Component | Intentional Change | Failure Location | Reason |
| :--- | :--- | :--- | :--- |
| **Loop Body** | Skipped `result := result * i;` | The `invariant result == FactorialFunction(i)` | The invariant holds for the old `i`. When `i` increments, the stored `result` is only $i!$ (because multiplication was skipped), which is not equal to $(i+1)!$, violating the invariant for the new value of `i`. |
| **Dafny Error** | | | *Loop invariant will not be maintained by the loop body.* |

### Case D: Failure Due to Incorrect Loop Variant (Factorial_Fail_Variant)

| Component | Intentional Change | Failure Location | Reason |
| :--- | :--- | :--- | :--- |
| **Loop Variant** (`decreases`) | `decreases n` | The `decreases n` clause | The variant expression must strictly decrease with every iteration. Since `n` is a constant and remains unchanged, it fails the strict decrease requirement, indicating a potential non-terminating loop. |
| **Dafny Error** | | | *The loop variant will not decrease.* |