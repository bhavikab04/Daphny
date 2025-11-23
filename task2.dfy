method FindFirstNegative(a: array<int>) returns (index: int)
  // Preconditions
  requires a.Length >= 0

  // Postconditions
  // 1. Result is within valid bounds (0 to a.Length)
  ensures 0 <= index <= a.Length
  // 2. If we found an index, the value there MUST be negative
  ensures index < a.Length ==> a[index] < 0
  // 3. If we found an index, everything BEFORE it must be non-negative
  ensures index < a.Length ==> forall k :: 0 <= k < index ==> a[k] >= 0
  // 4. If we returned a.Length (not found), then EVERYTHING must be non-negative
  ensures index == a.Length ==> forall k :: 0 <= k < a.Length ==> a[k] >= 0
{
  var i := 0;

  while i < a.Length
    // Loop Invariants (The "Why it works" logic)
    invariant 0 <= i <= a.Length
    // Crucial: We know everything checked so far (0 to i-1) is non-negative
    invariant forall k :: 0 <= k < i ==> a[k] >= 0
    decreases a.Length - i
  {
    if a[i] < 0 {
      return i;
    }
    i := i + 1;
  }
  return a.Length;
}

method Main() {
  // Test Case 1: Negative number in the middle (Expected: 2)
  var a := new int[5];
  a[0] := 0; a[1] := 1; a[2] := -5; a[3] := 3; a[4] := 4;

  var index1 := FindFirstNegative(a);
  print "Test 1: ", a[..], " | Result: ", index1, "\n";
  // Assert statements help check correctness during verification
  assert index1 == 2;

  // Test Case 2: No negative numbers (Expected: 4)
  var b := new int[4];
  b[0] := 1; b[1] := 2; b[2] := 3; b[3] := 4;

  var index2 := FindFirstNegative(b);
  print "Test 2: ", b[..], " | Result: ", index2, "\n";
  assert index2 == 4;

  // Test Case 3: Negative number at the start (Expected: 0)
  var c := new int[3];
  c[0] := -1; c[1] := 1; c[2] := 1;

  var index3 := FindFirstNegative(c);
  print "Test 3: ", c[..], " | Result: ", index3, "\n";
  assert index3 == 0;
}