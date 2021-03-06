{-# LANGUAGE OverloadedStrings, Arrows #-}
module Main where

import Prelude hiding (id)
import Control.Monad (forM_)
import Data.Monoid (mempty)
import Text.Pandoc (WriterOptions(..))
import Data.List(intercalate,intersperse)
import qualified Text.Blaze.Html5 as H
import Text.Blaze ((!), toValue)
import Text.Blaze.Html (toHtml)
import Text.Blaze.Html.Renderer.String(renderHtml)
import qualified Text.Blaze.Html5.Attributes as A
import Control.Category (id)
import Control.Arrow ((>>>), arr, (&&&), (***), (<<^), returnA)
import Data.Maybe (catMaybes, fromMaybe)

import Hakyll
import Text.Pandoc.Shared

title = "Andres"
author = "Andres"
description = "Insights about natural, artificial and fictitious intelligence."
keywords = "programming, haskell, linux, freedom"
url = "http://p-q.github.com"

config = defaultHakyllConfiguration { inMemoryCache = False }

main :: IO ()
main = hakyllWith config $ do
    -- Copy static content
    mapM_ (flip match $ route idRoute >> compile copyFileCompiler)
      [ "images/**" , "js/**", "code/**", "test.html", "robots.txt" ] 

    -- Compress and copy css
    match "css/*" $ route idRoute >> compile compressCssCompiler

    match "index.html" $ do
      route idRoute
      create "index.html" $ constA mempty
        >>> arr (setField "title" title)
        >>> arr (setField "description" description)
        >>> arr (setField "keywords" keywords)
        >>> arr (setField "bodyclass" "default")
        >>> arr (setField "tagcloud" "")
        >>> setFieldPageList (take 10 . recentFirst)
                "templates/postitem.html" "posts" "posts/*"
        >>> applyTemplateCompiler "templates/index.html"
        >>> arr checkMathOption
        >>> applyTemplateCompiler "templates/default.html"

    match "posts.html" $ do
      route idRoute
      create "posts.html" $ constA mempty
        >>> arr (setField "title" "Posts")
        >>> arr (setField "bodyclass" "postlist")
        >>> arr (setField "tagcloud" "")
        >>> setFieldPageList recentFirst
                "templates/postitem.html" "posts" "posts/*"
        >>> applyTemplateCompiler "templates/posts.html"
        >>> arr checkMathOption
        >>> applyTemplateCompiler "templates/default.html"

    match "posts/*" $ do
      route $ setExtension ".html"
      compile $ blogCompiler
        >>> arr (renderDateField "date" "%Y-%m-%d" "Date unknown")
        >>> arr (copyBodyToField "description")
        >>> arr (setField "keywords" keywords)
        >>> arr (setField "bodyclass" "post")
        >>> arr (setField "tagcloud" "")
        >>> renderTagsField "prettytags" (fromCapture "tags/*")
        >>> applyTemplateCompiler "templates/post.html"
        >>> applyTemplateCompiler "templates/disqus.html"
        >>> arr checkMathOption
        >>> applyTemplateCompiler "templates/default.html"
        >>> relativizeUrlsCompiler

    -- Tags
    create "tags" $
      requireAll "posts/*" (\_ ps -> readTags ps :: Tags String)

    -- Add a tag list compiler for every tag
    match "tags/*" $ route $
      gsubRoute "C\\+\\+" (const "Cpptag") `composeRoutes` setExtension "html"
    metaCompile $ require_ "tags"
      >>> arr tagsMap
      >>> arr (map (\(t, p) -> (tagIdentifier t, makeTagList t p)))
        
    -- Render RSS feed
    match "rss.xml" $ route idRoute
    create "rss.xml" $ requireAll_ "posts/*" >>> renderRss feedConfiguration
            
    -- Read templates
    match "templates/*" $ compile templateCompiler

    -- Render pages with relative url's
    forM_ ["about.md","404.md"] $ \p ->
      match p $ do
        route $ setExtension ".html"
        compile $ blogCompiler
           >>> arr (setField "tagcloud" "")
           >>> arr checkMathOption
           >>> applyTemplateCompiler "templates/default.html"
           >>> relativizeUrlsCompiler


renderTagCloud' :: Compiler (Tags String) String
renderTagCloud' = renderMyTags tagIdentifier

tagIdentifier :: String -> Identifier (Page String)
tagIdentifier = fromCapture "tags/*"  
      
makeTagList :: String -> [Page String] -> Compiler () (Page String)
makeTagList tag posts =
  constA posts
    >>> pageListCompiler recentFirst "templates/postitem.html"
    >>> arr (copyBodyToField "posts" . fromBody)
    >>> arr (setField "title" $ "Posts tagged " ++ tag)
    >>> arr (setField "description" $ "View all posts tagged with " ++ tag)
    >>> arr (setField "keywords" $ "tags, " ++ tag)
    >>> arr (setField "bodyclass" "postlist")
    >>> requireA "tags" (setFieldA "tagcloud" renderTagCloud')
    >>> applyTemplateCompiler "templates/posts.html"
    >>> arr checkMathOption
    >>> applyTemplateCompiler "templates/default.html"

blogCompiler :: Compiler Resource (Page String)
blogCompiler = pageCompilerWith defaultHakyllParserState opts
  where opts = defaultHakyllWriterOptions
                 { writerHtml5 = True
                 , writerTableOfContents = True
                 , writerLiterateHaskell = True
                 , writerHTMLMathMethod = MathJax ""
                 }

feedConfiguration :: FeedConfiguration
feedConfiguration = FeedConfiguration
    { feedTitle = title
    , feedDescription = description
    , feedAuthorName = author
    , feedAuthorEmail = "pq@lavabit.com"
    , feedRoot = url
    }

renderMyTags :: (String -> Identifier (Page a)) -> Compiler (Tags a) String
renderMyTags makeUrl = proc (Tags tags) -> do
    tags' <- mapCompiler ((id &&& (getRouteFor <<^ makeUrl)) *** arr length)
                -< tags
    returnA -< renderHtml $ mapM_ toHtml (intersperse (toHtml (" " :: String)) (map makeItem tags'))

makeItem :: ((String, Maybe FilePath), Int) -> H.Html
makeItem ((tag, maybeUrl), count) =
      H.a ! A.href (toValue url) $ toHtml tag
        where url = toUrl $ fromMaybe "/" maybeUrl

checkMathOption :: Page String -> Page String
checkMathOption page =
  case getFieldMaybe "math" page of
     Nothing -> setField "mathjax" "" page
     Just _  -> setField "mathjax" "<script type=\"text/javascript\" src=\"http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML\" />" page
