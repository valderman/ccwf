{-# LANGUAGE OverloadedStrings, RecordWildCards, TupleSections #-}
import Hakyll
import Control.Monad
import Data.Char
import Data.List
import Data.Time
import System.Directory (doesFileExist)
import System.FilePath (takeBaseName)
import Text.Read

-------------------------------------------------------------------------
-- * News, lectures and files. Routine updates should mostly happen here.
-------------------------------------------------------------------------

-- | Latest news, in order from newest to latest. Can contain markdown.
newsItems :: [Item String]
newsItems = map (Item (fromFilePath "")) $
  [ "June 28. Responsive design - it now looks *fabulous* on mobile devices!"
  , "June 27. Birth of the new course homepage."
  ]

-- | All lectures for the course. These make up the table on the @lectures@
--   page.
--
--   Make sure to put any files mentioned in the list of lecture files
--   into the @files@ subdirectory before rebuilding the course homepage, to
--   ensure that they all get included.
lectures :: [Lecture]
lectures =
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
miscFiles :: [FilePath]
miscFiles = ["runtime.ll", "Javalette.cf", "tester.tar.gz"]


----------------------------------------------------------------------------
-- * Course-specific configuration - should only need changing once per year
----------------------------------------------------------------------------

-- | Name of course responsible, plus email.
--   This is parameterized to make course handovers easier, since the name
--   and/or email of the course responsible pops up here and there throughout
--   the project description and course homepage..
--
--   First name is available to templates as @teacher@, full name as
--   @teacherfull@, email as @teacheremail@, bio URL as @teacherbio@, phone
--   as @teacherphone@, office as @teacheroffice@ and office hours as
--   @teacherhours@.
--
--   Currently, the examiner and the de facto course responsible are not one
--   and the same. If this situation changes, or if the examiner changes, don't
--   forget to make the appropriate modifications to @pages/about.md@.
--
--   Similarly, if the course should evolve to need more than one assistant,
--   or add change the duties of the course responsible or assistant ,
--   please update @pages/about.md@ as appropriate. Use 'labDeadlines'
--   and its use in @pages/exam.md@ as an example of adding a list of things
--   to a page.
teacher :: Teacher
teacher = Teacher
  { teacherName   = "Alex Gerdes"
  , teacherEmail  = "alexg \"at\" chalmers.se"
  , teacherBioURL = Just "http://www.cse.chalmers.se/~alexg"
  , teacherPhone  = "+46 31 772 6154"
  , teacherOffice = Just "Room 6466 in the EDIT building."
  , teacherHours  = Just "Thursdays 13:15 - 15:00"
  }

-- | Same information as for 'teacher'. All fields are available to templates
--   the same as for @teacher@, but with the prefix @assistant@ instead of
--   @teacher@.
assistant :: Teacher
assistant = Teacher
  { teacherName   = "Anton Ekblad"
  , teacherEmail  = "antonek \"at\" chalmers.se"
  , teacherPhone  = "+46 31 772 1028"
  , teacherBioURL = Just "http://ekblad.cc"
  , teacherOffice = Just "Room 5463 in the EDIT building."
  , teacherHours  = Nothing
  }

-- | URL of the official course syllabus for 2017.
--   This changes every year: don't forget to update!
--   Available to templates as @syllabus@.
syllabusURL :: String
syllabusURL = "https://www.student.chalmers.se/sp/course?course_id=24405"

-- | URL of the Google group for this year's instance. Don't forget to update!
--   Available to templates as @group@.
googleGroupURL :: String
googleGroupURL = "javascript:alert('No group yet!');"

-- | URL of this year's Fire instance. Don't forget to update!
--   Available to templates as @fire@.
fireURL :: String
fireURL = "javascript:alert('No Fire yet!');"

-- | URL of the course's TimeEdit schedule. Available to templates as
--   @timeedit@.
timeEditURL :: String
timeEditURL = "https://se.timeedit.net/web/chalmers/db1/public/ri1X50gQ1560YvQQ05Z6779Y0Zy6007331Y50Q089.html"

-- | The deadlines for the three labs.
--   Available to templates as @deadline1/2/3@.
labDeadlines :: [String]
labDeadlines =
  [ "Sunday, April 24 at 23:59"
  , "Sunday, May 15 at 23:59"
  , "Sunday, May 29 at 23:59"
  ]


---------------------------------------------------
-- * Only implementation details beyond this point.
---------------------------------------------------

data Teacher = Teacher
  { teacherName   :: String
  , teacherEmail  :: String
  , teacherPhone  :: String
  , teacherBioURL :: Maybe String
  , teacherOffice :: Maybe String
  , teacherHours  :: Maybe String
  }

data Lecture = Lecture
  { lectureDate        :: String
  , lectureDescription :: String
  , lectureFiles       :: [(String, FilePath)]
  }

main = do
  -- Check that all lecture files are present
  (courseYear, _, _) <- toGregorian . utctDay <$> getCurrentTime
  let files = [ "./files/" ++ file
              | fs <- map lectureFiles lectures
              , (_, file) <- fs
              ] ++ map ("./files/" ++) miscFiles
  files' <- filterM (fmap not . doesFileExist) files
  unless (null files') $ do
    putStrLn $ "The following essential files could not be found:"
    forM_ files' $ putStrLn . ("  " ++)
    error "Some files were missing from the ./files directory!"

  hakyll $ do
    -- CSS files are just compressed
    match "css/*" $ do
      route idRoute
      compile compressCssCompiler

    -- JS files are just copied
    match "js/*" $ do
      route idRoute
      compile copyFileCompiler

    -- Images too
    match "images/*" $ do
      route idRoute
      compile copyFileCompiler

    -- Lectures files are copied into files/
    match "files/*" $ do
      route idRoute
      compile copyFileCompiler

    -- Don't do anything fancy with templates
    match "templates/*" $ do
      compile templateCompiler

    -- Add an explicit dependency on this file
    match "website.hs" $ do
      compile $ makeItem ()
    hsdep <- makePatternDependency "website.hs"

    -- Pages are read from the @pages@ subdirectory.
    rulesExtraDependencies [hsdep] $ match "pages/*.md" $ do
      route $ gsubRoute "pages/" (const "")
            `composeRoutes` gsubRoute ".md" (const "")
            `composeRoutes` customRoute (mkPath . toFilePath)
      compile $ do
        metas <- getAllMetadata "pages/*.md"
        self <- takeBaseName <$> getResourceFilePath
        let -- Menu items, sorted by their menuorder metadata entry.
            -- Items without menuorder are sorted randomly among themselves,
            -- after any entries with a specified order.
            menuitems = map snd $ sortBy (\a b -> compare (fst a) (fst b)) $
              [ (menuOrder meta, Item (noIndex ident) title)
              | (ident, meta) <- metas
              , Just title <- [lookupString "title" meta]
              ]
            -- Context for the page content; contains metadata set in the
            -- markdown file for each page, as well as some info set at the
            -- top of this file.
            ctx = mconcat
              [ constField "year" (show courseYear)
              , constField "syllabus" syllabusURL
              , constField "group" googleGroupURL
              , constField "fire" fireURL
              , constField "timeedit" timeEditURL
              , mconcat
                  [ constField ("deadline" ++ show num) date
                  | (date, num) <- zip labDeadlines [1..]
                  ]
              , teacherFields "teacher" teacher
              , teacherFields "assistant" assistant
              , listField "menuitems" (mkMenuCtx self)
                                      (pure menuitems)
              , listField "lectures" mkLectureCtx
                                     (mapM (makeItem . fst) (zip [0..] lectures))
              , if length newsItems > 3
                  then listField "news" defaultContext (pure newsItems)
                  else mempty
              , listField "latestnews" defaultContext (pure $ take 3 newsItems)
              , defaultContext
              ]
        applyMeAsTemplate ctx ctx

-- | Create context fields for a teacher.
teacherFields :: String -> Teacher -> Context a
teacherFields prefix (Teacher {..}) = mconcat
  [ constField prefix (head $ words teacherName)
  , constField (prefix ++ "full") teacherName
  , constField (prefix ++ "email") teacherEmail
  , constField (prefix ++ "bio") (maybe "" id teacherBioURL)
  , constField (prefix ++ "phone") teacherPhone
  , maybe mempty (constField (prefix ++ "office")) teacherOffice
  , maybe mempty (constField (prefix ++ "hours")) teacherHours
  ]

-- | Get the menu order from a piece of metadata.
menuOrder :: Metadata -> Int
menuOrder meta =
  maybe 1000000
    (round :: Double -> Int)
    (readMaybe =<< lookupString "menuorder" meta)

-- | Set the CSS class of a menu item based on its identifier and the
--   identifier of the current page. If the identifier matches the current
--   page, the item should be displayed as selected.
menuItemClass :: String -> Item a -> String
menuItemClass current itm
  | current == takeBaseName (toFilePath (itemIdentifier itm)) =
    "selected"
  | current == "index" && null (toFilePath (itemIdentifier itm)) =
    "selected"
  | otherwise =
    "unselected"

mkLectureCtx :: Context Int
mkLectureCtx = mconcat
  [ field "date" $ \(Item _ n) -> do
      pure $ lectureDate (lectures !! n)
  , field "description" $ \(Item _ n) -> do
      pure $ show $ lectureDescription (lectures !! n)
  , listFieldWith "lecturefiles" defaultContext $ \(Item _ n) -> do
      pure $ [ Item (fromFilePath file) name
             | (name, file) <- lectureFiles $ lectures !! n]
  , field "number" $ \(Item _ n) -> 
      pure $ show (n+1)
  ]

-- | Build the context for the menu. The @submenuitems@ field will contain all
--   sub-menu items for the currently active page.
--   Note that URLs are relativized in a horrible, hacky way, which needs to
--   be changed if the directory hierarchy of the course homepage changes.
mkMenuCtx :: String
          -> Context String
mkMenuCtx self = mconcat
  [ field "selected" (pure . menuItemClass self)
  , listFieldWith "submenuitems" defaultContext $ \itm -> do
      when (takeBaseName (toFilePath (itemIdentifier itm)) /= self) $ do
        fail "not my submenu"
      submenuitems <- words <$> getMetadataField' (itemIdentifier itm) "submenu"
      forM (zip (mkTitles submenuitems) submenuitems) $ \(title, ident) -> do
        pure $ Item (fromFilePath $ "#" ++ ident) title
  , field "url" $ pure . itemToUrl
  , defaultContext
  ]
  where
    itemToUrl = ("/" ++) . takeBaseName . toFilePath . itemIdentifier
    mkTitles = map capitalize . map toSpaces

    capitalize (x:xs) = toUpper x : xs

    toSpaces = map toSpace

    toSpace '_' = ' '
    toSpace c   = c

-- | Render the current page as markdown, then use the current page as a
--   template (i.e. it may include substitutions), and render it as markdown
--   again. Finally, apply the default template to the end result and
--   relativize all URLs.
applyMeAsTemplate :: Context String -> Context String -> Compiler (Item String)
applyMeAsTemplate pageCtx topCtx = do
  getResourceBody
    >>= renderPandoc
    >>= applyAsTemplate pageCtx
    >>= renderPandoc
    >>= loadAndApplyTemplate "templates/default.html" topCtx
    >>= relativizeUrls

-- | Turn a path @p@ (stripped of prefix and extension) into @p/index.html@.
mkPath :: FilePath -> FilePath
mkPath "index" = "index.html"
mkPath p       = p ++ "/index.html"

-- | Turn an identifier into an empty identifier if the identifier is @index@,
--   otherwise return the identifier unchanged.
noIndex :: Identifier -> Identifier
noIndex ident
  | takeBaseName (toFilePath ident) == "index" = fromFilePath ""
  | otherwise                                  = ident
