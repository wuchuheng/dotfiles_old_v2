#!/usr/bin/env zsh

echo -n "Please type the new tag name like v0.0.1:"
read newTag

echo " " >> CHANGELOG.md
echo "## ${newTag}" >> CHANGELOG.md
git log $(git describe --tags --abbrev=0)..HEAD | grep '  ' | grep -v Date | sed 's/^    /- /' >> CHANGELOG.md

bash .github/workflows/get_change_log.sh "${newTag}"

