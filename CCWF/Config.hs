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
  , lectures       :: [Lecture]
    -- | Files that are related to the course, but not tied to any particular
    --   lecture.
  , miscFiles      :: [FilePath]
  }

-- | Course information: this should change only about once per year.
data Info = Info
  { -- | The main teacher of the course.
    teacher        :: Teacher
    -- | The examiner of the course, if different from the main teacher.
  , examiner       :: Maybe Teacher
    -- | Any assistants working on the course.
    --   The name, email, etc. of the first assistant in the list are accessible
    --   as @assistant@, @assistantemail@, etc.
  , assistants     :: [Teacher]
    -- | URL of the course syllabus. This is mandatory for all Chalmers courses.
  , syllabusURL    :: URL
    -- | URL of the course's Google group, if any.
  , googleGroupURL :: Maybe URL
    -- | URL of the course's lab submission system, if any.
  , submissionURL  :: Maybe URL
    -- | URL of external schedule for course, if any.
  , scheduleURL    :: Maybe URL
    -- | All lab deadlines.
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
  , lectureFiles       :: [(String, FilePath)]
  }
