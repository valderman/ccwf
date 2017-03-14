import CCWF

-------------------------------------------------------------------------
-- * News, lectures and files. Routine updates should mostly happen here.
-------------------------------------------------------------------------

materials = Materials
  { -- Latest news, in order from newest to latest. Can contain markdown.
    newsItems =
      [ "June 28. Responsive design - it now looks *fabulous* on mobile devices!"
      , "June 27. Birth of the new course homepage."
      ]

    -- All lectures for the course. These make up the table on the @lectures@
    -- page.
    --
    -- Make sure to put any files mentioned in the list of lecture files
    -- into the @files@ subdirectory before rebuilding the course homepage, to
    -- ensure that they all get included.
  , lectures =
      [ Lecture "April 12" "Introduction, project overview"
          [("slides", "example-01.txt")]
      , Lecture "April 15" "How not to make a course website"
          [("slides", "example-02.txt"), ("code", "example.php")]
      ]

    -- Files we provide that are not tied to any particular lecture.
  , miscFiles = []
  }

----------------------------------------------------------------------------
-- * Course-specific configuration - should only need changing once per year
----------------------------------------------------------------------------

info = Info
  { -- The human-readable name of the course.
    courseName = "Constructing Great Course Websites"
    -- The official course code(s).
  , courseCode = "TDA000/DIT000"
    -- The study period in which the course is given.
  , studyPeriod = 4
    -- The year this particular course is given.
  , courseYear = 2017
    -- Name of course responsible, plus email.
    -- This is parameterized to make course handovers easier, since the name
    -- and/or email of the course responsible pops up here and there throughout
    -- the project description and course homepage..
    --
    --  First name is available to templates as @teacher@, full name as
    -- @teacherfull@, email as @teacheremail@, bio URL as @teacherbio@, phone
    -- as @teacherphone@, office as @teacheroffice@ and office hours as
    -- @teacherhours@.
  , teacher = Teacher
      { teacherName   = "Alice Teacher"
      , teacherEmail  = "alice \"at\" example.com"
      , teacherBioURL = Just "http://alice.example.com"
      , teacherPhone  = "(placeholder number)"
      , teacherOffice = Just "Some room"
      , teacherHours  = Just "Thursdays 13:15 - 15:00"
      }

    -- The examiner of the course, if different from the course responsible.
  , examiner = Nothing
      
    -- Same information as for 'teacher'. All fields of the first assistant
    -- are available to templates the same as for @teacher@, but with the
    -- prefix @assistant@ instead of @teacher@.
    -- The full list of assistants is available as @assistants@.
  , assistants =
      [ Teacher
          { teacherName   = "Bob Assistant"
          , teacherEmail  = "assistant \"at\" example.com"
          , teacherPhone  = "(placeholder number)"
          , teacherBioURL = Nothing
          , teacherOffice = Nothing
          , teacherHours  = Nothing
          }
      ]

    -- URL of the official course syllabus for 2017.
    -- This changes every year: don't forget to update!
    -- Available to templates as @syllabus@.
  , syllabusURL = "https://example.com/mycourse/syllabus"

    -- URL of the Google group for this year's instance. Don't forget to update!
    -- Available to templates as @group@.
  , googleGroupURL = Just "javascript:alert('No group yet!');"

    -- URL of the lab submission system used this year, if any.
    -- Don't forget to update!
    -- Available to templates as @submissions@.
  , submissionURL = Just "javascript:alert('No lab submissions yet!');"

    -- URL of the course's official schedule. Available to templates as
    -- @schedule@.
  , scheduleURL = Just "https://example.com/mycourse/schedule"

    -- The deadlines for the labs.
    -- Available to templates as @deadline1/2/3/n@.
  , labDeadlines =
      [ "Sunday, April 24 at 23:59"
      , "Sunday, May 15 at 23:59"
      , "Sunday, May 29 at 23:59"
      ]
  }

main = mkWebsite (Website info materials)
