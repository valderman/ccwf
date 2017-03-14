import CCWF

-------------------------------------------------------------------------
-- * News, lectures and files. Routine updates should mostly happen here.
-------------------------------------------------------------------------

materials = Materials
  { -- | Latest news, in order from newest to latest. Can contain markdown.
    newsItems =
      [ "June 28. Responsive design - it now looks *fabulous* on mobile devices!"
      , "June 27. Birth of the new course homepage."
      ]

    -- | All lectures for the course. These make up the table on the @lectures@
    --   page.
    --
    --   Make sure to put any files mentioned in the list of lecture files
    --   into the @files@ subdirectory before rebuilding the course homepage, to
    --   ensure that they all get included.
  , lectures =
      [ Lecture "April 12" "Introduction, project overview"
          [("old", "lect01-6up.pdf")]
      , Lecture "April 15" "Software Engineering for Compilers"
          [("old", "lect02-6up.pdf"), ("code", "state.tar.gz")]
      , Lecture "April 22" "LLVM: tools, language"
          [("old", "lect03-6up.pdf")]
      , Lecture "April 26" "Code generation for LLVM"
          [("old", "lect04-6up.pdf"), ("code", "evenodd.ll")]
      , Lecture "May 3"    "Project extensions: arrays, dynamic structures, objects"
          [("old", "lect05-6up.pdf")]
      , Lecture "May 10"   "Code generation for x86"
          [("old", "lect06-6up.pdf")]
      , Lecture "May 13"   "Functions"
          [("old", "lect07-6up.pdf")]
      , Lecture "May 16"   "Control flow graphs, data analysis"
          [("old", "lect08-6up.pdf")]
      , Lecture "May 24"   "Guest lecture/project summary"
          [("old", "lect09-6up.pdf"), ("guest", "/guest_lecture_myreen-6up.pdf")]
      ]

    -- | Files we provide that are not tied to any particular lecture.
  , miscFiles = ["runtime.ll", "Javalette.cf", "tester.tar.gz"]
  }

----------------------------------------------------------------------------
-- * Course-specific configuration - should only need changing once per year
----------------------------------------------------------------------------

info = Info
  { -- | Name of course responsible, plus email.
    --   This is parameterized to make course handovers easier, since the name
    --   and/or email of the course responsible pops up here and there throughout
    --   the project description and course homepage..
    --
    --   First name is available to templates as @teacher@, full name as
    --   @teacherfull@, email as @teacheremail@, bio URL as @teacherbio@, phone
    --   as @teacherphone@, office as @teacheroffice@ and office hours as
    --   @teacherhours@.
    teacher = Teacher
      { teacherName   = "Alex Gerdes"
      , teacherEmail  = "alexg \"at\" chalmers.se"
      , teacherBioURL = Just "http://www.cse.chalmers.se/~alexg"
      , teacherPhone  = "+46 31 772 6154"
      , teacherOffice = Just "Room 6466 in the EDIT building."
      , teacherHours  = Just "Thursdays 13:15 - 15:00"
      }

    -- | The examiner of the course, if different from the course responsible.
  , examiner = Nothing
      
    -- | Same information as for 'teacher'. All fields of the first assistant
    --   are available to templates the same as for @teacher@, but with the
    --   prefix @assistant@ instead of @teacher@.
    --   The full list of assistants is available as @assistants@.
  , assistants =
      [ Teacher
          { teacherName   = "Anton Ekblad"
          , teacherEmail  = "antonek \"at\" chalmers.se"
          , teacherPhone  = "+46 31 772 1028"
          , teacherBioURL = Just "http://ekblad.cc"
          , teacherOffice = Just "Room 5463 in the EDIT building."
          , teacherHours  = Nothing
          }
      ]

    -- | URL of the official course syllabus for 2017.
    --   This changes every year: don't forget to update!
    --   Available to templates as @syllabus@.
  , syllabusURL = "https://www.student.chalmers.se/sp/course?course_id=24405"

    -- | URL of the Google group for this year's instance. Don't forget to update!
    --   Available to templates as @group@.
  , googleGroupURL = Just "javascript:alert('No group yet!');"

    -- | URL of the lab submission system used this year, if any.
    --   Don't forget to update!
    --   Available to templates as @submissions@.
  , submissionURL = Just "javascript:alert('No Fire yet!');"

    -- | URL of the course's TimeEdit schedule. Available to templates as
    --   @schedule@.
  , scheduleURL = Just "https://se.timeedit.net/web/chalmers/db1/public/ri1X50gQ1560YvQQ05Z6779Y0Zy6007331Y50Q089.html"

    -- | The deadlines for the three labs.
    --   Available to templates as @deadline1/2/3@.
  , labDeadlines =
      [ "Sunday, April 24 at 23:59"
      , "Sunday, May 15 at 23:59"
      , "Sunday, May 29 at 23:59"
      ]
  }

main = mkWebsite (Website info materials)
