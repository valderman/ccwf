---
title: Lectures
menuorder: 6
---

Lectures
========


Lectures take place on Tuesdays 13-15 in EL41 and Fridays 13-15 in EL42.
Not all available times are used. The complete schedule is available in
[TimeEdit](\$timeedit\$). Note that if you use an iCal or vCal-compatible
calendar, you can download the course schedule from TimeEdit.

The following is a preliminary plan for the lectures. Changes will be announced
on this web site. Slides from the lectures will normally be available on this
page in advance of the lecture.

Last year's slides are already here. Changes may occur; a new version is
indicated by changing 'old' to 'new' in the links below.

<table class="lectures" border="1" cellspacing="0" cellpadding="5" valign="top">
<tr>
<th align="center">Lecture #</th>
<th>Date</th>
<th>Topic</th>
<th align="center">Slides</th>
</tr>
\$for(lectures)\$
<tr>
<td align="center">\$number\$</td>
<td>\$date\$</td>
<td align="left">\$description\$</td>
<td align="center">
\$for(lecturefiles)\$
[\$body\$](/files/\$path\$)
\$endfor\$
</td>
</tr>
\$endfor\$
</table>
