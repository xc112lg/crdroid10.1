#!/bin/bash

# Check if gh command-line tool is installed
if ! command -v gh &> /dev/null; then
  echo "Error: GitHub CLI (gh) is not installed. Please install it from https://cli.github.com/ and try again."
  exit 1
fi

# Ensure the user is authenticated with GitHub
gh auth login

# Ask for the release tag name
read -p "Enter the release tag name: " version


# Create the tag and push it to GitHub
git tag -a "$version" -m "Release $version"
git push origin "$version"  --force

# Initialize an array to store the filenames
declare -a filenames

#if [[ "$upload_all" =~ ^[Yy]$ ]]; then
  # Upload all .zip and .img files in the current directory
  filenames=(*.zip *.img)
#else
  # Ask the user to input the filenames
#  read -p "Enter the filenames (separated by spaces): " -a filenames
#fi


#!/bin/bash

echo "Enter the version:"
read -r version

# Check if the release already exists
if gh release view "$version" &>/dev/null; then
  # If the release exists, prompt the user
  echo "Release $version already exists. Do you want to overwrite it? (yes/no)"
  read -r response

  if [[ "$response" =~ ^[Yy][Ee][Ss]$ ]]; then
    # User chose to overwrite
    echo "Overwriting the existing release..."
  else
    # User chose to cancel
    echo "Canceling the release."
    exit 1
  fi
fi

# Attempt to create the release
if ! gh release create "$version" --title "Release $version" --notes "Release notes"; then
  echo "Error: Failed to create the release."
  exit 1
fi


# Upload the files to the release
for filename in "${filenames[@]}"; do
  gh release upload "$version" "$filename" --clobber
done

# Display success message
echo "Files uploaded successfully."
