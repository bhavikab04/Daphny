# **Method: FindFirstNegative**

The FindFirstNegative method is a verified linear search algorithm that iterates through an integer array to find the index of the first negative value. If no negative numbers are found, the method correctly returns the length of the array to indicate the "not found" status.

The implementation is verified for correctness, ensuring that it not only finds a negative number if one exists but specifically finds the *first* one, and correctly reports if none exist.

## **Preconditions**

Preconditions define the constraints that must be met before the method is called.

* **Array Validity:** The input array a must have a non-negative length (a.Length \>= 0). This is a standard requirement for array processing, though Dafny naturally enforces non-negative lengths for array types.

## **Postconditions**

The postconditions serve as a contract, guaranteeing the state of the result (index) after the method executes.

1. **Result Bounds:** The returned index will always be in the range \[0, a.Length\].  
2. **Valid Detection:** If index is strictly less than a.Length, the value at a\[index\] is guaranteed to be negative (a\[index\] \< 0).  
3. **First Occurrence Guarantee:** If a negative value is found at index, the method ensures that *no* negative values exist at any index k before it (0 \<= k \< index). This proves it is the *first* negative number.  
4. **Not Found Integrity:** If the method returns a.Length, it guarantees that the entire array contains no negative numbers (i.e., forall k :: 0 \<= k \< a.Length \==\> a\[k\] \>= 0).

## **Loop Invariant**

The loop invariants explain "why it works" to the verifier, acting as the inductive proof of correctness during the iteration.

1. **Bounds Logic:** The loop counter i is strictly maintained within the valid range 0 \<= i \<= a.Length.  
2. **Partial Correctness (The "Crucial" Invariant):** At the start of every iteration i, the algorithm has already verified that all elements checked so far (indices 0 to i-1) are non-negative.  
   * invariant forall k :: 0 \<= k \< i \==\> a\[k\] \>= 0  
   * This ensures that if the loop eventually finds a negative number at i, it is genuinely the *first* one because strictly everything before i was non-negative. Conversely, if the loop reaches the end (i \== a.Length), this invariant implies the entire array is non-negative.