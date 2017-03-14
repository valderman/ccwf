Chalmers Course Website Framework
=================================

A (hopefully) extensible and easy-to-use framework for creating and managing
course websites.


Overview
--------

The homepage is largely configurable from the build script, `website.hs`, which
is divided into two sections.

The first section contains information which is likely to change as the course
progresses: news items, lectures and files to be published on the course homepage.
The second section contains information which is likely to change from year to
year, such as information about the course responsible and assistants, various
URLs, etc.

The settings in these two sections are made available to the markdown-based
pages of the course homepage through *template variables*. Please see the
Haddock for each setting for more information on how to use them.

The third section contains the build script itself, which is unlikely to change
very much at all. This part is largely considered implementation details.

Page content lives in the `pages` directory as markdown files; one file per
page on the course homepage. Larger edits -- modifications to the project
description, updates from course evaluation meetings, etc. -- are made to the
relevant markdown file. Please remember to *avoid* including information such
as the name of the examiner, URL of the Google group, etc. verbatim in these
pages. Instead, use the template variables `\$teacher\$`, `\$group\$`, etc.,
to ensure that this information is kept consistent across all pages and is
easy to update if the course changes hands.
Note that if you want to use a `$` -- that is, a literal dollar sign -- you
should use the `S` environment variable.

Files -- lecture notes, the test suite, etc. -- live in the `files` directory.
Any files you want to distribute should be put in this directory and linked
from the appropriate news item or markdown page.

The look of the course homepage mainly lives in the `css` and `templates`
directories. Please exercise caution when updating the CSS and HTML in these
directories, as you might inadvertently break the site for mobile devices.
Make sure to test any changes both in your normal browsing environment and with
your browser window shrunk to less 750 pixels wide.


Day to day tasks
----------------

### Rebuilding the site

To rebuild the site, simply run `runghc website.hs build`. If the build has
somehow become messed up, use `runghc website.hs rebuild` to rebuild it from
scratch.


### Deploying the updated site

After rebuilding the site, deploy it by copying the contents of the `_site`
directory to the appropriate directory on the Chalmers server. You should
use `rsync` for this, to avoid updating any files that were not changed. An
example of a deployment command line would be
`rsync -r _site/* /path/to/homepage/root`.


### Updating news

To add a news item, simply add a line to the `newsItems` list and rebuild the
site. Make sure that the prefixes of the lines are consistent, i.e. give the
date that the news item was added. News items may contain markdown, so you can
add emphasis, links and other styling.


### Lectures

To update a lecture, simply add/remove/modify the relevant entry in the
`lectures` list and rebuild the site. Each lecture has three fields:

* the date of the lecture;
* the title of the lecture; and
* a list of (title, file name) pairs, containing files (usually slides) tied
    to the lecture.

Don't forget to put any files you added/changed into the `files` directory.
If you removed a file from the list, you should also remove it from the `files`
directory.
