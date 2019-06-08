robocopy src docs /e
robocopy build\contracts docs
git add .
git commit -m "Adding frontend files to GitHub pages from deploy script"
git push