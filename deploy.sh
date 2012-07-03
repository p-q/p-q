#!/bin/sh

echo $@
git status
read

runhaskell p-q.hs rebuild
rm -rf _deploy/* # does not delete dotfiles (git stuff)
cp -R _site/* _deploy

cd _deploy
  git add .
  git commit -m "$(echo $@)"
  git push -u origin master
cd ../

git add .
git commit -m "$(echo $@)"
git push -u origin master

