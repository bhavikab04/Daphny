# Project: Daphny

Course name: Logic in Computer Science

## Team members

- S Dharshana `2023B5A71208H`
- Bhavika Baburaj `2023B5A71210H`
- Vedika Nirmal Kumar Singh `2023B4A71359H`
- Sri Pujitha Konjeti `2023B1A71384H`

## Project Layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage and Task 5.
        AbsoluteValue_Doc.md #Task 1
        FindFirstNegative_Doc.md #Task 2
        Factorial_Doc.md #Task 3
        Tribonacci_Doc.md #Task 4

## **About the Project**

### **Overview**

This project was developed as part of Assignment 2 for the course CS F214: Logic in CS.
The main goal of this assignment is to explore Formal Software Verification using the Dafny programming language. Unlike regular programming, where one writes tests for code to be run on certain inputs, in this project, one will write mathematical proofs embedded directly into the code. We define strict specifications so that the software is guaranteed to behave correctly for all possible inputs.

### **Core Concepts Explored**

During the course of this project, we implemented several algorithms and proved them correct using the following Dafny constructs:

- **Preconditions (requires):** constraints that must be true prior to calling a method (e.g. array length is non-negative).
- **Postconditions (ensures):** Conditions that are guaranteed about the system state once a method has completed execution.
- **Loop Invariants (invariant):** Logical properties that hold before and after every iteration of a loop; used in the proof of **Partial Correctness**.
- **Loop Variants (decreases):** A measure that strictly decreases with every iteration to prove **Termination** (Total Correctness).

### **Project Tasks**

The problems in this project involve four different algorithmic tasks, from simple arithmetic to complex sequence generation:

#### **Task 1: Absolute Value**

**Goal:** Implement a method to compute the absolute value of an integer.

- **Focus:** Basic method syntax and postconditions.
- **Verification:** Proved that the output is always non-negative and matches the mathematical definition $|x|$.

#### **Task 2: Find First Negative**

**Goal:** Perform a linear search to find the index of the first negative number in an array.

- **Focus:** Array manipulation and search logic.
- **Verification:** Proved that the method correctly identifies the _first_ occurrence (ensuring no negative numbers exist before the index found) and handles cases where no negative numbers exist.

#### **Task 3: Factorial**

**Goal:** Use iteration to implement the computation of $n\!$.

- **Focus:** Linking iterative implementations to recursive mathematical specifications.
- **Verification:** Used a recursive ghost function FactorialFunction to prove that the iterative accumulation correctly computes the mathematical factorial.

#### **Task 4: Tribonacci Sequence**

**Goal:** Use an iterative approach to find the $n$-th term of the Tribonacci sequence
`T_n = T_(n-1) + T_(n-2) + T_(n-3)`

- **Focus:** Complex loop invariants using a "sliding window" approach.
- **Verification:** Maintained invariants for three variables simultaneously to prove the iterative step matches the recursive definition without the performance cost of recursion.

### **Tools Used**

- **Language:** [Dafny](https://dafny.org/) (Microsoft Research)
- **IDE:** Visual Studio Code with Dafny Extension
- **Verification Engine:** Boogie / Z3 Theorem Prover
