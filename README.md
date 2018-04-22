# PA2 template
This project is a homework template prepared specially for the course PA2 (thought at Czech Technical University in Prague, Faculty of Information Technology). Its purpose is to make the homework assignments easier to complete. Short overview of what it provides:
  - Makefile that compiles code
  - Test script
  - Useful make commands (targets)
  - It allows separation of code into files and then merging them into a single file for submition

## Separation into files

Progtest requires only 1 file to be submitted and therefore it is not possible to follow the standard approach and to separate the code into header files and source files to make the project easier to navigate in. Also separation into multiple files yields into fewer code errors at a time (as the compiler stops after first failed attemt to compile a file). This template provides a useful tool that allows such approach. It merges the files together in a smart way that it is still possible to compile the file and get the same program. However few things needs to be avoided or taken special care of - static gloval variables, using directives and function name colisions.

## Typical flow
  - Get the template for a new assignment via - git clone https://github.com/simon-hrabec/PA-2-Template.git
  - Copy test data/write your own tests and put them into the test directory
  - Write your code
  - Compile it - make all
  - Test it - make test
  - When the homework assignment is about to be submitted, pack it into one file - make progtest. It tries to compile the merged source code and run tests on it to validate it.
