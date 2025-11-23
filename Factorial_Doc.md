# **Method: Factorial**

The Factorial method iteratively computes the factorial of a non-negative integer n. The correctness of this implementation is verified against a purely mathematical recursive specification (FactorialFunction).

The method avoids recursion in its implementation, utilizing a while loop to accumulate the product, which is often more memory-efficient for large inputs in compiled languages.

## **Preconditions**

* **Natural Number Input:** The input n is constrained to the type nat, meaning it must be a non-negative integer (n \>= 0). This is enforced by the type system and the method signature.

## **Postconditions**

* **Verification against Specification:** The returned value f must be exactly equal to the result of the recursive specification FactorialFunction(n). This links the iterative code directly to the mathematical truth of factorials.

## **Loop Invariant**

The loop invariants link the iterative state (variables i and result) to the mathematical definition as the loop progresses.

1. **Range Validity:** The counter i remains within the bounds 0 \<= i \<= n throughout the execution.  
2. **Accumulation Integrity:** At the start of every iteration, the variable result holds the correct factorial value for the current counter i.  
   * invariant result \== FactorialFunction(i)  
   * **Initialization:** When i=0, result is 1 (since $0\! \= 1$).  
   * **Maintenance:** As i increments, result is updated to result \* i, maintaining the invariant that result equals $i\!$.  
   * **Termination:** When the loop finishes, i \== n. Because the invariant holds, result must equal FactorialFunction(n).