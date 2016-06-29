---
title: Home
menuorder: 0
---

Compiler Construction
=====================

This is the course homepage for the Chalmers course Compiler Construction
(TDA283/DIT300) given in study period 4, \$year\$.


Latest news
-----------
<div id="latestnews">
\$for(latestnews)\$
* \$body\$\
\$endfor\$
\$if(news)\$
<a class="newslink" href="javascript:toggle('hide', ['allnews', 'latestnews']);">Older news...</a>
\$endif\$
</div>
\$if(news)\$
<div id="allnews" class="hide">
\$for(news)\$
* \$body\$\
\$endfor\$
<a class="newslink" href="javascript:toggle('hide', ['allnews', 'latestnews']);">Less news...</a>
</div>
\$endif\$


Course essentials
-----------------

* The course consists of a single project: constructing a
    [compiler for a small, Java-like programming language](/project) in groups
    of **one to three** students. Groups of **two** are recommended.
* To pass the course, you must pass
    **three hand-ins** via the [Fire system](/about#submissions), and a short
    **oral exam** during the exam week. See "[examination](/exam)" for details,
    dates and deadlines.
* The hand-ins test your ability to **produce a working compiler**, and
    determine your grade for this course. Make sure that your compiler
    [passes the test suite](/project#testing) before submitting.
    **Deadlines are strict**; extensions will only be granted under
    exceptional circumstances, and even then only if requested *before the
    deadline in question has passed*.
* The oral exam tests that **all group members** have been actively involved in
    the project and share a full understanding of the compiler.
    You will be asked to **present your compiler** to the examiner, who will
    then ask you some questions about it.
    *Someone else did X, I worked on Y instead* is *not* considered a valid
    answer.
* You must hand in your final submission **before** being allowed to take the
    oral exam. No exceptions to this rule will be considered.
* Your grade is determined by **the extensions you implement**.
    Your performance on the oral exam will *not* affect your grade other than
    passing or failing.
* The course has a [Google group](\$group\$) where you can find a group
    partner, ask general questions pertaining to the course, etc.
    Detailed questions about your own code are better asked by email to your
    supervisor or in person during office hours.
* Relevant litterature, software tools, and the `runtime.ll` file containing
    the I/O routines for your Javalette programs can be found in the
    [resources](/resources) section.
