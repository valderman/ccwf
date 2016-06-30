---
title: Examination
menuorder: 3
---

Examination
===========

The examination in this course consists of two parts: a project and an oral
exam. In order to pass the course you must complete the mandatory parts of
the projects -- a working **frontend and LLVM code generator**, as well as
at least **one language extension** -- and pass the **oral exam**.
For a [higher grade](/project#grading) there are several extensions available
to the project which you can do.
See the [project description](/project#extensions) for more information about
each extension.

Things which are considered when grading the project:

* The language and any extensions **must be handled in full generality**.
  It is not sufficient to only be able to compile the programs in the test suite.
* Code quality does not affect the grade in general. But **the code must hold
  a minimum of readability** so that the grader can make sense of it.
* The project documentation is not graded either but must contain the required
  information stated in the project description below.
* We only give points to **fully working solutions**. No partial credits for
  partial solutions. However, we do allow for resubmissions for minor bug fixes.


<a name="project"></a>

Project
-------

The main part of the course is a project, where you implement a complete
compiler for a simple imperative language called Javalette. The project is
done in groups of one or two students; we recommend that you work in pairs.

The project is described in the [project instruction](/project).
The project is divided into three parts with separate submission dates:

1. **Frontend**. The front end does lexing, parsing and type checking and builds
    a suitable intermediate representation. Your compiler must accept all
    programs in the good directory and reject all programs in the bad directory.
    Your submission must be prepared according to appendix A in the project
    description and pass the automatic tester.
    
    Front end issues are part of the syllabus for the prerequisite course
    Programming language technology. These things are not taught in this course.
    You are expected to be able to implement the lexer, parser and typechecker
    for Javalette using previous knowledge during the first week of this course.
   
    The deadline for the first submission is **\$deadline1\$**. The deadline is
    sharp; the submission system will not accept late submissions. Of course,
    if you are ill or have another good reason, you may get an extended
    deadline, but you must then explicitly ask for an extension in an email
    to Alex, explaining the reason. This email must be sent before the deadline.
2. **Backend for LLVM**. Again, your compiler must reject all bad programs and
    be able to run all good programs. There are also test programs for the
    various extensions.
    The deadline for this second submission is **\$deadline2\$**.
3. **Language extensions** and/or back end generating native x86 code.
    The deadline for this submission is **\$deadline3\$**.

All parts are submitted using the [Fire](/fire) system.


Oral exam
---------

In the exam week there will be brief individual [oral exams](/oral).
Schedules for these will be decided the preceding week. The objective of the
exam is to test the student's understanding of his/her project.


Re-sit exam
-----------

In the re-exam week in August you have the opportunity to redo the oral exam.
This will take place on **Tuesday 16 August 2016 and Friday 19 August from 13:00
to 15:00**. Please contact \$teacher\$ to book a time slot. You need to send your
compiler at least a week in advance to \$teacher\$.
