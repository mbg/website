--------------------------------------------------------------------------------
-- Michael B. Gale's Website
-- Copyright 2016 Michael B. Gale (michael.gale@cl.cam.ac.uk)
--------------------------------------------------------------------------------

-- | The module containing the main entry point for this application.
module Main (main) where

--------------------------------------------------------------------------------

import Data.Monoid

import Hakyll

--------------------------------------------------------------------------------

-- | The Hakyll configuration.
config :: Configuration
config = defaultConfiguration

defaultTemplate :: Identifier
defaultTemplate = "templates/default.html"

staticPages =
    [ "activities.html"
    , "teaching.html"
    , "projects.html"
    ]

--------------------------------------------------------------------------------

blogCtx :: Tags -> Context String
blogCtx tags = mconcat
    [ modificationTimeField "mtime" "%U"
    , dateField "date" "%e %B %Y"
    , tagsField "tags" tags
    , defaultContext
    ]

talkCtx :: Context String
talkCtx = mconcat
    [ modificationTimeField "mtime" "%U"
    , dateField "date" "%e %B %Y"
    , defaultContext
    ]

--------------------------------------------------------------------------------

-- | Patterns which describe the static files that should be copied
--   to the output directory.
staticPatterns :: Pattern
staticPatterns = "fonts/**"
            .||. "slides/**"
            .||. "files/**"
            .||. "images/*.jpg"
            .||. "images/*.png"

-- | Rules to copy static files to the output directory.
staticFiles :: Rules ()
staticFiles = match staticPatterns $ do
    route idRoute
    compile copyFileCompiler

--------------------------------------------------------------------------------

-- | Processes all files related to the blog.
blog :: Rules ()
blog = do
    tags <- buildTags "blog/*.md" (fromCapture "tags/*.html")

    match "blog/*.md" $ do
        route $ setExtension ".html"
        compile $ do
            pandocCompiler
                >>= saveSnapshot "content"
                >>= return . fmap demoteHeaders
                >>= loadAndApplyTemplate "templates/post.html" defaultContext
                >>= loadAndApplyTemplate defaultTemplate defaultContext
                >>= relativizeUrls

    create ["blog.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll ("blog/*.md")
            let ctx = constField "title" "Blog" <>
                      listField "posts" (blogCtx tags) (return posts) <>
                      defaultContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/blog.html" ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx
                >>= relativizeUrls

    tagsRules tags $ \tag pat -> do
        let title = "Articles tagged " ++ tag

        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll pat
            let ctx = constField "title" title <>
                      listField "posts" (blogCtx tags) (return posts) <>
                      defaultContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/blog.html" ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx
                >>= relativizeUrls

--------------------------------------------------------------------------------

-- |
research :: Rules ()
research = do
    -- build a page for every publications
    match "publications/*" $ do
        route $ setExtension ".html"
        compile $ do
            pandocCompiler
                >>= saveSnapshot "content"
                >>= return . fmap demoteHeaders
                >>= loadAndApplyTemplate "templates/publication.html" defaultContext
                >>= loadAndApplyTemplate defaultTemplate defaultContext
                >>= relativizeUrls

    -- build an index page for the publications
    create ["publications.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll ("publications/*")
            let ctx = constField "title" "Publications" <>
                      listField "posts" talkCtx (return posts) <>
                      defaultContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/publications.html" ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx
                >>= relativizeUrls

    -- build a page for every talk
    match "talks/*" $ do
        route $ setExtension ".html"
        compile $ do
            pandocCompiler
                >>= saveSnapshot "content"
                >>= return . fmap demoteHeaders
                >>= loadAndApplyTemplate "templates/talk.html" defaultContext
                >>= loadAndApplyTemplate defaultTemplate defaultContext
                >>= relativizeUrls

    create ["talks.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll ("talks/*")
            let ctx = constField "title" "Talks" <>
                      listField "posts" talkCtx (return posts) <>
                      defaultContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/talks.html" ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx
                >>= relativizeUrls

    match "research.html" $ do
        route idRoute
        compile $ do
            talks  <- fmap (take 2) . recentFirst =<< loadAll "talks/*"
            papers <- fmap (take 2) . recentFirst =<< loadAll "publications/*"

            let researchContext =
                    listField "talks" defaultContext (return talks) <>
                    listField "papers" defaultContext (return papers) <>
                    defaultContext

            getResourceBody
                >>= applyAsTemplate researchContext
                >>= loadAndApplyTemplate defaultTemplate researchContext
                >>= relativizeUrls

--------------------------------------------------------------------------------

-- | The main entry point of this program.
main :: IO ()
main = hakyllWith config $ do
    -- static files
    staticFiles

    -- compress CSS
    match "css/*" $ do
        route idRoute
        compile compressCssCompiler

    blog
    research

    match (fromList staticPages) $ do
        route idRoute
        compile $ do
            getResourceBody
                >>= loadAndApplyTemplate defaultTemplate defaultContext
                >>= relativizeUrls

    -- Process the main index page
    match "index.html" $ do
        route idRoute
        compile $ do
            papers <- fmap (take 3) . recentFirst =<< loadAll "publications/*"

            let indexContext =
                    constField "title" "Home" <>
                    listField "papers" defaultContext (return papers) <>
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexContext
                >>= loadAndApplyTemplate defaultTemplate indexContext
                >>= relativizeUrls

    -- Process templates
    match "templates/*" $ compile templateCompiler

--------------------------------------------------------------------------------
