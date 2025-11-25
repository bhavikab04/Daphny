# **Method: FindFirstNegative**

The FindFirstNegative method is a verified linear search algorithm that iterates through an integer array to find the index of the first negative value. If no negative numbers are found, the method correctly returns the length of the array to indicate the "not found" status.

The implementation is verified for correctness, ensuring that it not only finds a negative number if one exists but specifically finds the _first_ one, and correctly reports if none exist.

## **Preconditions**

Preconditions define the constraints that must be met before the method is called.

- **Array Validity:** The input array a must have a non-negative length `(a.Length >= 0)`. This is a standard requirement for array processing, though Dafny naturally enforces non-negative lengths for array types.

## **Postconditions**

The postconditions serve as a contract, guaranteeing the state of the result (index) after the method executes.

1. **Result Bounds:** The returned index will always be in the range `[0, a.Length]`.
2. **Valid Detection:** If index is strictly less than a.Length, the value at `a[index]` is guaranteed to be negative `(a[index] < 0)`.
3. **First Occurrence Guarantee:** If a negative value is found at index, the method ensures that _no_ negative values exist at any index k before it `(0 <= k < index)`. This proves it is the _first_ negative number.
4. **Not Found Integrity:** If the method returns a.Length, it guarantees that the entire array contains no negative numbers `(i.e., forall k :: 0 <= k < a.Length ==> a[k] >= 0)`.

## **Loop Invariant**

The loop invariants explain "why it works" to the verifier, acting as the inductive proof of correctness during the iteration.

1. **Bounds Logic:** The loop counter i is strictly maintained within the valid range `0 <= i <= a.Length`.
2. **Partial Correctness (The "Crucial" Invariant):** At the start of every iteration i, the algorithm has already verified that all elements checked so far (indices 0 to i-1) are non-negative.
   - `invariant forall k :: 0 <= k < i ==> a[k] >= 0`
   - This ensures that if the loop eventually finds a negative number at i, it is genuinely the _first_ one because strictly everything before i was non-negative. Conversely, if the loop reaches the end `(i == a.Length)`, this invariant implies the entire array is non-negative.

## Recorded initial failures

- In the first version of the code, I encountered a verification error when I set `requires a != null` as one of the preconditions.

- The error `variable 'a' to have the value 'null'` happened because in modern Dafny, arrays are _"non-null"_ by default.
  Since I explicitly asked the verifier to check `requires a != null`, which is now redundant and causes an error.

- It has started working from the 2nd version.

## Cases Where Verification Failed (Failing Proofs)

If a specification element is incorrect or missing, Dafny's verifier will fail the proof. These failures are critical because they highlight **logical gaps** in the formal proof.

---

### Failure Case A: Missing Postcondition (`ensures`)

This failure occurs when a required property of the output is omitted, violating the intended logic (finding the **first** negative number).

| Element                   | Description/Change                                                               | Dafny's Failure Point                                                                             | Rationale for Failure                                                                                                                                                                                   |
| :------------------------ | :------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Missing Postcondition** | Omitted: `ensures index < a.Length ==> forall k :: 0 <= k < index ==> a[k] >= 0` | The verifier only proves the method found _a_ negative number, not the **first** one.             | The lack of a constraint on $0 \le k < index$ allows the method to skip earlier negative numbers. <br><br> For example, the verifier technically accepts `index = 4` for the array `[1, -1, 1, 1, -5]`. |
| **Result**                | Omit the postcondition that guarantees non-negativity before the result.         | The verifier cannot prove the final state is correct because the specification is **incomplete**. | The verifier can only ensure the element at `index` is negative, not that it is the **earliest** one.                                                                                                   |

---

### Failure Case B: Weak Loop Invariant

This is a structural proof failure. The loop invariant is the only mechanism that allows Dafny to carry proof knowledge from the beginning of the loop to its end.

| Element                    | Description/Change                                        | Dafny's Failure Point                                                                                                                                              | Rationale for Failure                                                      |
| :------------------------- | :-------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------- |
| **Missing Loop Invariant** | Omitted: `invariant forall k :: 0 <= k < i ==> a[k] >= 0` | **Assertion Failure on Exit:** The verifier cannot prove the postcondition `ensures index == a.Length ==> forall k :: 0 <= k < a.Length ==> a[k] >= 0`.            |
| **Reason**                 | Omit the core logic that tracks the history of the loop.  | When the loop finishes, $i = a.Length$. Without this invariant, Dafny has **no memory** that the array elements checked up to $i-1$ were ever proven non-negative. | The proof **collapses** because the proof history inside the loop is lost. |
