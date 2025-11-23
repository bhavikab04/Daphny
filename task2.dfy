method FindFirstNegative(a: array<int>) returns (index: int)
  // Preconditions: I'm putting the conditons that must be true before the loop runs here:
  requires a.Length >= 0         // 1. The array length must be non-negative.
  //The condition of the array being non-empty is not necessary, as the method can handle empty arrays correctly.

  // Postconditions: These'll be true after the method finished executing
  ensures 0 <= index <= a.Length                         // 1. The returned index must be within the bounds [0, a.Length].
  ensures (index < a.Length) ==> (a[index] < 0)          // 2. If index < a.Length, then a[index] is the first negative number.
  ensures (index < a.Length) ==> (forall k :: 0 <= k < index ==> a[k] >= 0) // 3. All elements before the returned index must be non-negative.
  ensures (index == a.Length) ==> (forall k :: 0 <= k < a.Length ==> a[k] >= 0) // 4. If index == a.Length, no negative number was found.
{
  var i := 0;

  // Loop Invariant (Partial Correctness): 
  while i < a.Length
    invariant 0 <= i <= a.Length                          // I1: Loop index is within bounds [0, a.Length]. (Needed for termination)
    invariant forall k :: 0 <= k < i ==> a[k] >= 0        // I2: All elements from index 0 up to i-1 are non-negative.
    // Loop Variant (Total Correctness): proves that the loop will eventually terminate
    decreases a.Length - i
  {
    if a[i] < 0 {
      // Found the first negative number!
      return i;
    }
    i := i + 1;
  }

  // If the loop finishes without returning, it means no negative number was found.
  return a.Length;
}

method Main() {
  // Test Case 1: Negative number in the middle (Expected: 2)
  var a := new int[5](i => if i == 2 then -5 else i); 
  var index1 := FindFirstNegative(a);
  print "Array: ", a, " | Result: ", index1, "\n";

  // Test Case 2: No negative numbers (Expected: 4)
  var b := new int[4](i => i + 1); 
  var index2 := FindFirstNegative(b);
  print "Array: ", b, " | Result: ", index2, "\n";

  // Test Case 3: Negative number at the start (Expected: 0)
  // We create a new array where index 0 is -1
  var c2 := new int[3](i => if i == 0 then -1 else 1); 
  var index3 := FindFirstNegative(c2);
  print "Array: ", c2, " | Result: ", index3, "\n";
}