// --- 1. Specification: Recursive Factorial Function ---
// This pure function defines the mathematical specification of factorial (n!).
// It is used exclusively in the postcondition and loop invariant to verify
// the iterative method below.
function FactorialFunction(n: nat): nat
{
  if n == 0 then 1 else n * FactorialFunction(n-1)
}

//Iterative Factorial Method :
method Factorial(n: nat) returns (f: nat)
  // Precondition :
  // The input 'n' is constrained to 'nat' (non-negative integer).
  requires true // n: nat is sufficient for the domain
  
  // Postcondition (ensures): What must be true when the method finishes.
  // The result 'f' must equal the mathematically defined factorial of 'n'.
  ensures f == FactorialFunction(n)
{
  var i := 0;      // Current number processed. We iterate from 0 up to n.
  var result := 1; // Accumulator for the factorial product.

  // Loop that iterates until i reaches n
  while i < n
    // Loop Invariant (Partial Correctness): A property that holds true at the 
    // start of the loop, before every iteration, and when the loop terminates.
    invariant 0 <= i <= n // i is always within the valid range [0, n]
    invariant result == FactorialFunction(i) // 'result' holds the factorial of 'i'
    
    // Loop Variant (Total Correctness): A non-negative integer expression that 
    // strictly decreases with every loop iteration, guaranteeing termination.
    decreases n - i
  {
    i := i + 1;
    result := result * i;
  }

  f := result;
}

// --- 3. Execution Block: Main Method ---
method Main()
{
    var n_test := 5;
    var result := Factorial(n_test);
    print "Factorial of ", n_test, " is: ", result, "\n"; // Expected: 120

    n_test := 0;
    result := Factorial(n_test);
    print "Factorial of ", n_test, " is: ", result, "\n"; // Expected: 1

    n_test := 10;
    result := Factorial(n_test);
    print "Factorial of ", n_test, " is: ", result, "\n"; // Expected: 3628800
}