# **Method: FindFirstNegative**

The FindFirstNegative method is an algorithm designed to search through an integer array to locate the index of the first negative number. If the array contains no negative numbers, the method returns the length of the array.

This method employs a linear search strategy, iterating through the array from the beginning until a negative value is encountered or the end of the array is reached.

## **Preconditions**

Preconditions define the state that must be true before the method is called. For FindFirstNegative, the requirements are minimal:

* **Valid Array Length:** The length of the input array a must be non-negative (a.Length \>= 0).  
  * *Note:* Dafny handles empty arrays (length 0\) correctly within the logic, returning 0 as the "not found" index equivalent to the length.

## **Postconditions**

Postconditions guarantee the state of the system after the method has finished executing. They formally define the correctness of the result index.

1. **Bounds Safety:** The returned index is guaranteed to be within the inclusive range \[0, a.Length\].  
2. **Correct Identification:** If the returned index is less than the array length, the element at that position (a\[index\]) is strictly less than 0\.  
3. **First Occurrence Property:** If a negative number is found at index, all elements preceding it (indices 0 to index-1) must be non-negative. This ensures the method finds the *first* negative number, not just *any* negative number.  
4. **Not Found Scenario:** If the returned index equals a.Length, it implies that no negative numbers exist in the entire array (i.e., all elements are non-negative).

## **Loop Invariant**

To prove the loop functions correctly and terminates, Dafny uses loop invariants. These are properties that hold true before and after every iteration.

1. **Bounds Maintenance:** The loop counter i always remains within the valid range 0 \<= i \<= a.Length.  
2. **Search Progress (Partial Correctness):** At any point i in the loop, we have verified that all elements examined so far (from index 0 to i-1) are non-negative.  
   * invariant forall k :: 0 \<= k \< i \==\> a\[k\] \>= 0  
   * This invariant is crucial because if the loop terminates by reaching a.Length, this logic proves that *every* element in the array was checked and found to be non-negative.