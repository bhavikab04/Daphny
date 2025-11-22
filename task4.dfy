// 1. Mathematical Definition (Specification)
// This function defines the truth of what a Tribonacci number is.
// It is used by Dafny to verify the code but is not compiled into the executable program.
function Trib(n: nat): nat
{
    if n == 0 then 0
    else if n == 1 then 1
    else if n == 2 then 1
    else Trib(n-1) + Trib(n-2) + Trib(n-3)
}

// 2. Iterative Method Implementation
method ComputeTrib(n: nat) returns (res: nat)
    // Precondition: n must be a natural number (enforced by type 'nat', but stated for clarity)
    requires n >= 0
    // Postcondition: The result must equal the mathematical definition of the nth Tribonacci number
    ensures res == Trib(n)
{
    // Base case for 0
    if n == 0 {
        return 0;
    }

    // Initialize variables
    // We maintain a window of three numbers: a, b, c corresponding to T(i-1), T(i), T(i+1)
    var i := 1;
    var a := 0; // T(0)
    var b := 1; // T(1)
    var c := 1; // T(2)

    // Loop to compute up to n
    while i < n
        // Loop Invariants (Partial Correctness)
        // 1. Range of i
        invariant 1 <= i <= n
        // 2. 'a' is always the (i-1)th Tribonacci number
        invariant a == Trib(i-1)
        // 3. 'b' is always the ith Tribonacci number
        invariant b == Trib(i)
        // 4. 'c' is always the (i+1)th Tribonacci number
        invariant c == Trib(i+1)
        
        // Loop Variant (Total Correctness)
        // Must decrease with every iteration and be bounded by 0
        decreases n - i
    {
        // Calculate the next term: T(i+2) = T(i+1) + T(i) + T(i-1)
        var next := a + b + c;
        
        // Shift the window forward
        a := b;
        b := c;
        c := next;
        
        // Increment counter
        i := i + 1;
    }

    // When the loop terminates, i == n.
    // The invariant 'invariant b == Trib(i)' tells us that b == Trib(n).
    return b;
}

// Test method to prove it works for specific cases
method Main() 
{
    var t0 := ComputeTrib(0);
    assert t0 == 0;
    print "T(0) = ", t0, "\n";

    var t3 := ComputeTrib(3);
    assert t3 == 2; // 0 + 1 + 1 = 2
    print "T(3) = ", t3, "\n";
    
    var t4 := ComputeTrib(4);
    assert t4 == 4; // 1 + 1 + 2 = 4
    print "T(4) = ", t4, "\n";
}