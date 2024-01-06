#!/bin/bash
wget https://github.com/cli/cli/releases/download/v2.40.1/gh_2.40.1_linux_amd64.tar.gz
tar -xvf gh_2.40.1_linux_amd64.tar.gz
sudo mv gh_*_linux_amd64/bin/gh /usr/local/bin/
# Copy zip here
gh auth login
filename=$(ls *.zip)

# Create a tag and release using the filename (without .zip extension)
version=${filename%.zip}

git tag -a "$version" -m "Release $version"

git push origin "$version"

gh release create "$version" "$filename" -t "Release $version" -n "Release notes"
