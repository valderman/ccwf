{-# LANGUAGE OverloadedStrings, RecordWildCards, TupleSections #-}
module CCWF.Impl where
import Hakyll
import Control.Monad
import Data.Char
import Data.List
import Data.Time
import Data.Function (on)
import Data.Maybe (isJust, fromMaybe)
import System.Directory (doesFileExist)
import System.FilePath (takeBaseName)
import Text.Read
import CCWF.Config

-- | Build a website from a configuration.
mkWebsite :: Website -> IO ()
mkWebsite (Website (Info{..}) (Materials{..})) = do
  -- Check that all lecture files are present
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
            menuitems = map snd $ sortBy (compare `on` fst) $
              [ (order, Item (noIndex ident) title)
              | (ident, meta) <- metas
              , Just title <- [lookupString "title" meta]
              , Just order <- [menuOrder meta]
              ]
            -- Context for the page content; contains metadata set in the
            -- markdown file for each page, as well as some info set at the
            -- top of this file.
            ctx = mconcat
              [ constField "year" (show courseYear)
              , constField "coursename" courseName
              , constField "coursecode" courseCode
              , constField "studyperiod" (show studyPeriod)
              , constField "syllabus" syllabusURL
              , constField "group" (maybe "" id googleGroupURL)
              , constField "submissions" (maybe "" id submissionURL)
              , constField "schedule" (maybe "" id scheduleURL)
              , constField "S" "$"
              , mconcat
                  [ constField ("deadline" ++ show num) date
                  | (date, num) <- zip labDeadlines [1..]
                  ]
              , teacherFields "teacher" teacher
              , maybe mempty (teacherFields "examiner") examiner
              , case assistants of
                  (ass:_) -> teacherFields "assistant" ass
                  _       -> mempty
              , listField "assistants" mkTeacherListItemCtx (pure assistantItems)
              , listField "menuitems" (mkMenuCtx self)
                                      (pure menuitems)
              , listField "lectures" mkLectureCtx
                                     (zipWithM (curry makeItem) [1..] lectures)
              , if length newsItems > 3
                  then listField "news" defaultContext (pure newsItemItems)
                  else mempty
              , listField "latestnews" defaultContext (pure $ take 3 newsItemItems)
              , defaultContext
              ]
        applyMeAsTemplate ctx ctx
  where
    newsItemItems = map (Item (fromFilePath "")) newsItems
    assistantItems = map (Item (fromFilePath "")) assistants

-- | Create a list item context for a teacher.
--   Used for the list of assistants.
mkTeacherListItemCtx :: Context Teacher
mkTeacherListItemCtx = mconcat
  [ field "full" $ \(Item _ t) -> pure $ teacherName t
  , field "email" $ \(Item _ t) -> pure $ teacherEmail t
  , field "bio" $ \(Item _ t) -> maybe (fail "no bio") pure $ teacherBioURL t
  , field "phone" $ \(Item _ t) -> pure $ teacherPhone t
  , field "office" $ \(Item _ t) -> maybe (fail "no office") pure $ teacherOffice t
  , field "hours" $ \(Item _ t) -> maybe (fail "no hours") pure $ teacherHours t
  ]

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
--   If the menu order is "none" or a negative number, the page will not be
--   displayed in the menu. If the menu order is omitted 'maxBound' is assumed.
menuOrder :: Metadata -> Maybe Int
menuOrder meta =
  case lookupString "menuorder" meta of
    Just "none" -> Nothing
    Nothing     -> Just maxBound
    Just s      -> if order s < Just 0 then Nothing else order s
  where
    order = maybe badorder Just . readMaybe
    badorder = error "unable to read menuorder: not `none' or a number"

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

mkLectureCtx :: Context (Int, Lecture)
mkLectureCtx = mconcat
  [ field "date" $ \(Item _ (_, l)) -> do
      pure $ lectureDate l
  , field "description" $ \(Item _ (_, l)) -> do
      pure $ show $ lectureDescription l
  , listFieldWith "lecturefiles" defaultContext $ \(Item _ (_, l)) -> do
      pure $ [ Item (fromFilePath file) name
             | (name, file) <- lectureFiles l]
  , field "number" $ \(Item _ (n, _)) -> 
      pure $ show n
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
--   Pages may set a different template by setting the @template@ metadata
--   variable.
applyMeAsTemplate :: Context String -> Context String -> Compiler (Item String)
applyMeAsTemplate pageCtx topCtx = do
  template <- getTemplate
  getResourceBody
    >>= renderPandoc
    >>= applyAsTemplate pageCtx
    >>= renderPandoc
    >>= loadAndApplyTemplate template topCtx
    >>= relativizeUrls

-- | Get the template to use for the current page.
--   If no @template@ metadata is given, @default@ is assumed.
getTemplate :: Compiler Identifier
getTemplate = do
  self  <- getUnderlying
  mtemp <- getMetadataField self "template"
  return $ fromFilePath $  "templates/" ++ (fromMaybe "default" mtemp) ++ ".html"

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
