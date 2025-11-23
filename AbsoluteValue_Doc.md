# **Method: Abs**

The Abs method calculates the absolute value of a given integer x. It ensures that the result is the non-negative magnitude of the input, adhering to the standard mathematical definition of absolute value: $|x|$.

## **Preconditions**

There are no specific preconditions for this method other than the type constraint.

* **Input Type:** The input x must be an integer (int). It can be positive, negative, or zero.

## **Postconditions**

The method guarantees the following properties upon completion:

1. **Non-Negative Result:** The returned value x' is always greater than or equal to zero (x' \>= 0).  
2. **Mathematical Correctness:** The returned value satisfies the mathematical definition of absolute value:  
   * x' is equal to x (if x was positive or zero).  
   * OR x' is equal to \-x (if x was negative).

## **Loop Invariant**

This method does not contain any loops; it utilizes a simple conditional branching structure (if-else). Therefore, no loop invariants are required for verification.

* **Logic Flow:**  
  * If x \>= 0, the method returns x.  
  * If x \< 0, the method returns the negation \-x (which results in a positive integer).