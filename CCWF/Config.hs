-- | Per-website configuration for CCWF.
module CCWF.Config where

type URL = String

-- | A course website consists of relatively static course information, and
--   relatively static course materials.
data Website = Website
  { courseInfo      :: Info
  , courseMaterials :: Materials
  }

-- | Lectures, files and news items: course materials that will likely be
--   updated frequently.
data Materials = Materials
  { -- | Latest news for the course, in order from newest to latest.
    --   Can contain markdown.
    newsItems      :: [String]
    -- | All lectures for the course. These make up the table on the @lectures@
    --   page.
    --
    --   Make sure to put any files mentioned in the list of lecture files
    --   into the @files@ subdirectory before rebuilding the course homepage, to
    --   ensure that they all get included.
  , lectures       :: [Lecture]
    -- | Files that are related to the course, but not tied to any particular
    --   lecture.
  , miscFiles      :: [FilePath]
  }

-- | Course information: this should change only about once per year.
data Info = Info
  { -- | The human-readable name of the course.
    --   Available to pages as @coursename@.
    courseName     :: String
    -- | The course code of the course. Use the format @TDAabc/DITxyz@ if the
    --   course has two codes.
    --   Available to pages as @coursecode@.
  , courseCode     :: String
    -- | The study period in which the course is given. Available to pages as
    --   @studyperiod@.
  , courseYear     :: Int
    -- | The year in which the course is given. Available to pages as
    --   @year@.
  , studyPeriod    :: Int
    -- | Name of course responsible, plus email.
    --   This is parameterized to make course handovers easier, since the name
    --   and/or email of the course responsible pops up here and there throughout
    --   the project description and course homepage..
    --
    --   First name is available to templates as @teacher@, full name as
    --   @teacherfull@, email as @teacheremail@, bio URL as @teacherbio@, phone
    --   as @teacherphone@, office as @teacheroffice@ and office hours as
    --   @teacherhours@.
  , teacher        :: Teacher
    -- | The course examiner, if different from main teacher.
    --   Same information as for 'teacher'. All fields of the first assistant
    --   are available to templates the same as for @teacher@, but with the
    --   prefix @examiner@ instead of @teacher@.
  , examiner       :: Maybe Teacher
    -- | Same information as for 'teacher'. All fields of the first assistant
    --   are available to templates the same as for @teacher@, but with the
    --   prefix @assistant@ instead of @teacher@.
    --   The full list of assistants is available as @assistants@.
  , assistants     :: [Teacher]
    -- | URL of the course syllabus. This is mandatory for all Chalmers courses.
    --   This changes every year: don't forget to update!
    --   Available to templates as @syllabus@.
  , syllabusURL    :: URL
    -- | URL of the Google group for this year's instance. Don't forget to update!
    --   Available to templates as @group@.
  , googleGroupURL :: Maybe URL
    -- | URL of the lab submission system used this year, if any.
    --   Don't forget to update!
    --   Available to templates as @submissions@.
  , submissionURL  :: Maybe URL
    -- | URL of the course's official schedule. Available to templates as
    --   @schedule@.
  , scheduleURL    :: Maybe URL
    -- | All lab deadlines.
    --   Available to pages as @deadline1/2/3/...@.
  , labDeadlines   :: [String]
  }

-- | Bio for the teacher responsible for the course.
--   Name, phone and email are mandatory.
data Teacher = Teacher
  { -- | Full name of teacher.
    teacherName   :: String
    -- | Work email.
  , teacherEmail  :: String
    -- | Work phone.
  , teacherPhone  :: String
    -- | Does the teacher have a biography?
  , teacherBioURL :: Maybe URL
    -- | Room number of/directions to teacher's office.
  , teacherOffice :: Maybe String
    -- | Office hours, when the teacher is available for answering questions.
  , teacherHours  :: Maybe String
  }

-- | An entry in the list of course lectures.
data Lecture = Lecture
  { -- | When did the lecture take place?
    lectureDate        :: String
    -- | What was it about? Preferably one (short) sentence.
  , lectureDescription :: String
    -- | Any auxilliary material associated with the course.
    --   These files need to be present in the @files@ directory.
    --   Each file is given as a pair or @(displayed name, file name)@.
  , lectureFiles       :: [(String, FilePath)]
  }
