/*
Task 1: Write a method to compute the absolute value of an integer variable.
The signature of the method is: method Abs(x: int) returns (x': int)
*/

// A method to compute the absolute value of an integer x.
method Abs(x: int) returns (x': int)
  // Postcondition 1: The returned value (x') must be non-negative.
  ensures x' >= 0
  // Postcondition 2: The returned value (x') must be equal to x OR -x (the mathematical definition of absolute value).
  ensures x' == x || x' == -x
{
  if x >= 0 {
    // If x is non-negative, the absolute value is x itself.
    x' := x;
  } else {
    // If x is negative, the absolute value is the negation of x (which is positive).
    x' := -x;
  }
}

// This Main method is the standard entry point for execution.

method Main() {
  // Test case 1: Positive number
  var result1 := Abs(10);
  print "Abs(10) = ", result1, "\n"; // Expected: 10
  assert result1 == 10;

  // Test case 2: Negative number
  var result2 := Abs(-5);
  print "Abs(-5) = ", result2, "\n"; // Expected: 5
  assert result2 == 5;

  // Test case 3: Zero
  var result3 := Abs(0);
  print "Abs(0) = ", result3, "\n"; // Expected: 0
  assert result3 == 0;

  print "All absolute value tests passed and the method was verified by Dafny.\n";
}