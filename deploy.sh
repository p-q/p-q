#!/bin/sh
runhaskell p-q.hs rebuild
rm -rf _deploy/* # does not delete dotfiles (git stuff)
cp -R _site/* _deploy
cd _deploy
git add .
git commit -a -m "Auto-commit on `date`"
git push -u origin master
cd ../
