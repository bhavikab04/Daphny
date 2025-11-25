# **Method: Abs**

The Abs method calculates the absolute value of a given integer x. It ensures that the result is the non-negative magnitude of the input, adhering to the standard mathematical definition of absolute value: $|x|$.

## **Preconditions**

There are no specific preconditions for this method other than the type constraint.

- **Input Type:** The input x must be an integer (int). It can be positive, negative, or zero.

## **Postconditions**

The method guarantees the following properties upon completion:

1. **Non-Negative Result:** The returned value x' is always greater than or equal to zero `(x' >= 0)`.
2. **Mathematical Correctness:** The returned value satisfies the mathematical definition of absolute value:
   - x' is equal to x (if x was positive or zero).
   - OR x' is equal to \-x (if x was negative).

## **Loop Invariant**

This method does not contain any loops; it utilizes a simple conditional branching structure (if-else). Therefore, no loop invariants are required for verification.

- **Logic Flow:**
  - If `x >= 0`, the method returns x.
  - If `x < 0`, the method returns the negation \-x (which results in a positive integer).

## Cases where it fails

### Case A: The "Too Strict" Precondition (Verification Failure at Call Site)

**Hypothesis:** What if we force the user to only input positive numbers?

    dafny
    method AbsStrict(x: int) returns (x': int)
        requires x >= 0  // <--- BAD PRECONDITION for a general Abs function
        ensures x' == x
    {
        x' := x;
    }

    method Main() {
        var res := AbsStrict(-5); // ERROR: Verification Failed Here!
    }

**Result: VERIFICATION FAILED**.

**Reason**: The method AbsStrict is verified correctly internally (it does what it says it will do), but the Main method fails verification because we violated the requires `x >= 0` rule by passing -5.

### Case B: The "Wrong" Postcondition (Verification Failure in Logic)

**Hypothesis**: What if we promise that the output equals the input, even for negative numbers?

    method AbsWrong(x: int) returns (x': int)
        ensures x' == x // <--- WRONG POSTCONDITION
    {
        if x < 0 {
            x' := -x; // Logic returns positive
        } else {
            x' := x;
        }
    }

**Result: VERIFICATION FAILED.**

**Reason**: Dafny analyzes the if `x < 0` branch and finds a contradiction:

1. It sees `x = -5`.
2. The logic sets `x' = 5` (because -(-5) = 5).
3. The postcondition expects `x' == x `(i.e., it expects 5 == -5).
4. Since `5 == -5` is false, Dafny reports that the code does not satisfy the postcondition.
