---
title: Resources
menuorder: 7
---
Course literature and other resources
=====================================

The links to the resources on this page were verified on March 18, 2015.
Let \$teacher\$ know if you find any of them broken!


Text book
---------

The text book for the course is 
[Aho, Lam, Sethi and Ullman: Compilers: Principles, Techniques, and Tools, 2nd. ed](http://dragonbook.stanford.edu/) (Pearson International Edition 2007).
Available at Cremona and several web stores.


Additional useful texts
-----------------------

An excellent text book on modern compiling techniques is 
[Cooper and Torczon: Engineering a Compiler](http://www.elsevier.com/wps/find/bookdescription.cws_home/724559/description).
Focuses on backend issues; careful choice of material and very well written.

A somewhat dated but nice book on implementing lazy functional languages is
[Peyton-Jones and Lester: Implementing functional languages](http://research.microsoft.com/Users/simonpj/Papers/pj-lester-book/) (free download as PDF file).


Course discussion group
-----------------------

We have a Google group dedicated to questions and discussions pertaining to the
course. You may look for a project partner, ask questions of general interest,
answer questions from other students, etc. Detailed questions related to your
own code are better asked by email to your supervisor or in person during
office hours.

Anyone can read the discussions; to post you must become a member.
The group page is [here](\$group\$).


Software tools
--------------

Many software tools are available, in particular for front ends. We give just a few links.

For C programmers: Flex and Bison.
For Java programmers: [JLex](http://www.cs.princeton.edu/~appel/modern/java/JLex/)
and [CUP](http://www.cs.princeton.edu/~appel/modern/java/JLex/).
For Haskell programmers: [Alex](http://www.haskell.org/alex/)
and [Happy](http://www.haskell.org/happy/).
Common interface to all the above:
[BNF Converter](http://bnfc.digitalgrammars.com/).
Flex/Bison and Alex/Happy are installed on the Linux computers in lab rooms.
If you prefer to work in Java, download JLex/CUP.


Documentation for project languages
-----------------------------------

* **Javalette**.
    This language only exists as source language for the project in this
    course, even though it is strongly similar to subsets of C and Java.
    See the [project description](/project).
    The syntax of the base language is specified by the BNFC source file
    [Javalette.cf](/files/Javalette.cf). You may use this as the basis for
    your project. On the other hand, if you already have a BNFC file for a
    similar language (e.g. from the Programming Language Technology course),
    you might prefer that, if you have supporting code for e.g. type-checking.
    But you must then make sure to modify it to fit the description of
    Javalette.
* **LLVM**.
    Downloadable software, documentation and tutorials are available at the
    [LLVM home page](http://www.llvm.org/). In particular, you will need to
    consult the
    [LLVM Language Reference Manual](http://www.llvm.org/docs/LangRef.html)
    and the [LLVM Command Guide](http://www.llvm.org/docs/CommandGuide).
    The LLVM tools are available on the Studat Linux machines.
    The input/output routines are implemented in
    [runtime.ll](/files/runtime.ll).

* **x86 assembly language**.
    Two books are available for free download:
    * [Paul Carter: PC Assembly tutorial](http://www.drpaulcarter.com/pcasm/)
    * [Jonathan Bartlett: Programming from the ground up](http://download.savannah.gnu.org/releases/pgubook/ProgrammingGroundUp-1-0-booksize.pdf).

<a name="testsuite"></a>

Test program
------------

For your and our convenience, we provide a [test suite](/files/tester.tar.gz)
to help verify the correctness of your compiler, in the form of a collection of
Javalette test programs and a driver program that runs your compiler on these
test programs.

Unpack the archive in some suitable directory and follow instructions in
Appendix B in the [project description](/project).
