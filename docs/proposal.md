# Project Proposal

## Background
The book *The Elements of Computing Systems* walks students through the construction of a simulated computer system.
The student starts by building the basic logic gates in a simple hardware description language, starting with the NAND gate as the basic gate from which all others are built, and ends with a robust 16-bit computer system with graphical capabilities, programmable in a high-level programming language for which the student writes the compiler.
The [Nand2Tetris](https://www.nand2tetris.org/) website dedicated to this curriculum gets its name from the fact that the student following along in this book goes from assembling NAND gates into other logic gates to potentially writing a tetris game that can run on the computer they've built.
This process of starting from basic logic circuits and building up layers of abstraction to the point of having a working graphics-capable computer system helps impart a deep understanding of computing systems that is becoming rare among computer science students.

Our particular area of interest with this project, at least for now, is in the first three chapters of *The Elements of Computing Systems*.

## Scope
We would like to create a puzzle game based on the first few chapters of *The Elements of Computing Systems*. The game would have players assembling logic circuits visually, and having the circuits automatically tested to assess the nominal correctness and efficiency of their designs.

### Lack of Good Visualization Tools
The available tools for creating visual representations of the circuit designs created in the curriculum are not especially intuitive, reliable, or tailored to the curriculum.
// discuss problems with available tools? (logisim/digital)

### Encouraging Deeper Understanding of Computing Systems
"Building a Modern Computer from First Principles," as the subtitle of *Elements* goes, imparts a robust understanding of the various components that go into the computers we use.
This project will seek to entice users to pursue that understanding by presenting them with a an intuitive interface and integrating informative content into the gameplay environment.

## Functional Requirements
1. Easy menu navigation

    1.1. Select a level from a list of levels and load it.

2. Create gates and other components using preexisting components.
3. Keeping track of completed levels
4. Keep track of score

## References
[Nand2Tetris](https://www.nand2tetris.org/)

[The Elements of Computing Systems](https://www.nand2tetris.org/book)
