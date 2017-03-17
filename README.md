Chalmers Course Website Framework
=================================

A configurable and (hopefully) easy-to-use framework for creating and managing
course websites.
To see CCFW in action, visit the [example website](http://ekblad.cc/ccwf).


Quickstart
----------

To quickly get started with CCWF:

1. Clone this repository: `git clone https://github.com/valderman/ccwf.git`
2. Add your course information to the `website.hs` build script.
3. Modify the example website by adding, removing and modifying markdown files
   in the `pages` subdirectory.
4. Build your new course website: `runghc website.hs rebuild`
5. Commit your changes.
6. Whenever you need an official CCFW update, rebase your changes onto the
   latest changes: `git fetch && git rebase`


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
pages. Instead, use the template variables `$teacher$`, `$group$`, etc.,
to ensure that this information is kept consistent across all pages and is
easy to update if the course changes hands.

Files -- lecture notes, the test suite, etc. -- live in the `files` directory.
Any files you want to distribute should be put in this directory and linked
from the appropriate news item or markdown page.

All links should be relative to the course website root. That is, they should
start with `/`. Each page put into the `pages` subdirectory can be accessed
using its base name (i.e. file name without extension), prepended with a slash.
A link to the course "about" page would thus look like this:

```
[The "about" page](/about)
```

The look of the course homepage mainly lives in the `css` and `templates`
directories. Please exercise caution when updating the CSS and HTML in these
directories, as you might inadvertently break the site for mobile devices.
Make sure to test any changes both in your normal browsing environment and with
your browser window shrunk to less than 800 pixels wide.


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


Building your course website
----------------------------

<a name="create_page"></a>

### Creating a page

To create a new page, simply create a new markdown (`.md`) file in the `pages`
subdirectory. In addition to the standard Markdown formatting, pages can have
metadata, specified as `key: value` pairs at the top of the file.
See `pages/about.md` for an example "about" page.

Pages can have the following metadata items:

* `title`. This is the title of the page, which will be used for the page's
  entry in the main menu. It will also be displayed as the page title in the
  user's web browser (i.e. window/tab decoration) as well as in Google search
  results. If no title is given the page does not appear in the main menu.
* `submenu`. Pages may have submenus, linking to anchors within the page.
  A submenu is specified as a space-separated list of anchor names.
  An anchor by the name `anchor_name` can be declared by inserting the HTML
  code `<a name="anchor_name"></a>` somewhere on the page, and will appear
  in the submenu as "Anchor name", if it is also added to the `submenu` field.
* `menuorder`. A positive integer giving the page's place in the main menu.
  The main menu is sorted in ascending order, so that the page with the lowest
  menuorder appears at the top. If no menu order is given for a page, the page
  will be sorted *after* all other pages.
  If two pages share the same menu order, the ordering between them is
  arbitrary (but consistent; i.e. will always be the same).
  If `menuorder` is either `none` or a negative number, the page will not
  appear in the main menu at all (but can, of course, still be linked manually).
* `template`. The name of the template to use for this page.
  Templates live in the `templates` subdirectory, so if a page wants to use
  `mytemplate` as its template, the file `templates/mytemplate.html` will be
  loaded.


### Creating a page with a submenu

See the section [creating a page](#create_page); more specifically, the
discussion of the `submenu` metadata item.

<a name="custom_template"></a>

### Creating a page with a custom template

See the section [creating a page](#create_page); more specifically, the
discussion of the `template` metadata item.
In short:

1. Create a new template (or copy from `default.html` and modify) in the
   `templates` directory.
2. Set the `template` metadata variable to the name of your template, on all
   pages that should use the custom template.


### Creating a page with very wide content

Create a page as usual, but set the `template` metadata item for the page
to `wide`. This will apply the `widecontent` CSS class to
the contents of your page.


### Creating a page with a quickref bar

In addition to the left sidebar containing the website's main menu, pages on
course websites may have a right hand sidebar, called the "quickref bar".
This sidebar is intended for pages that contain a *lot* of text, such as
language definitions or descriptions of major course projects.

To create such a sidebar, insert a `div` HTML element with the `quickref`
CSS class anywhere on the page.
(We really suggest you put it at the top though, so it's easy to find when
you need to change it.)
In this element you can then put any markdown or HTML that you wish.
In our recommended use case, this would be a heading and a bulleted list of
links to anchors inserted somewhere on the page.
Anchors are inserted just like how they are inserted for use with a submenu.

The file `pages/quickref.md` contains an example usage of the quickref bar.


### Including code listings in pages

CCWF lets you include code listings with optional syntax highlighting on any
page. To include a one-line code snippet into running text, simply enclose it
in backticks: `` `print "hello"` ``.
These short snippets do not have syntax highlighting.

To include longer code listings, you can enclose a block of code in triple
backticks, where each set of backticks reside on a new line:

````
```
Beautiful listings
This one has no highlighting
It is a haiku
```
````

To add syntax highlighting to a code block, include the name of the language
the code is written in right next to the opening triple backticks:

````
```haskell
fib :: Integer -> Integer
fib 1 = 1
fib 2 = 1
fib n = fib (n-1) + fib (n-2)
```
````

If adding syntax highlighting to your code block doesn't change its appearance,
or has some other funny effect on the look of the page or the code block, your
language is most likely not supported.
In which case, simply leaving the language out will at least give you a
fixed-width font and a uniform look across code listings.


### Changing the look and feel of the entire website

To change the global look of your site, you should preferably make changes to
the CSS files in the `css` subdirectory.
The file `css/style.css` governs most of the site's look, such as the fonts,
colors, text decorations, etc.

For more drastic changes, such as completely changing the page structure or
adding some content to every single page, you will want to modify the default
template `templates/default.html`.
To only change the structure of *some* pages, you are better off creating a
new template, for use only on those pages. See the section
[creating a page with a custom template](#custom_template) for information
on how to do this.

When modifying either templates or CSS styling, it is **very important** to
test your changes both using a normal-sized browser window, and with your
browser window shrunk to <800 pixels wide (or, even better, on an actual
mobile device).
Otherwise, you risk breaking your website for either mobile or non-mobile
devices.


Troubleshooting
---------------

* Note that if you want to use a `$` -- that is, a literal dollar sign -- you
  should use the `S` environment variable, since actual dollar signs get eaten
  by the template compiler.
* Also note that in templates, newlines may sometimes also get eaten by the
  template compiler.
  Inserting a backslash (`\`) character at the end of a line affected
  by this problem will usually fix it.
* If a `$variable$` doesn't get properly interpolated, try escaping the dollar
  signs in its name: `\$variable\$`.
* When building tables or bullet points from lists (such as the `$assistant$`
  list, it is strongly recommended to use explicit HTML in your markdown pages,
  since the template compiler and the markdown compiler sometimes disagree on
  what some particular space or newline means.
  See the list of assistants on `pages/about.md`.
* If your code listings look weird, try not specifying a language.
  You won't get syntax highlighting, but you'll at least get a fixed-width font
  and a uniform look without messing up your page.
