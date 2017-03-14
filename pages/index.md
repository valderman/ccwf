---
title: Home
menuorder: 0
---

CCWF example course website
===========================

This is the course website for the course \$coursename\$
(\$coursecode\$) given in study period \$studyperiod\$, \$year\$.


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

* We recommend that you sum up the **most important** info points of the
  course here.
* You should make **liberal use** of bold font for **key phrases** and links
  to [relevant parts of the course website](/exam), to help the students get
  an overview of the course and **easily navigate the website**.
* While we're talking about important points, CCWF uses **responsive design**
  to keep your course website functional and attractive on **mobile devices**
  as well as on **larger screens**.
* Course websites are **parameterized** over important information, such as
  the responsible teacher, the course code, deadlines, various URLs, and more.
  This makes it **quick and easy** to update your course website for each new
  instance of the course, and **prevents errors** caused by forgetting to
  update some part of the text.
