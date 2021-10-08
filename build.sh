#!/bin/sh

echo 'Building the script...'

# move into the archive folder
cd archive

# create the zipped archive
tar -czf ../sfml_project.tar.gz .

# move back
cd ..

# generate the first portion of the script from src/main.sh
cat src/main.sh > sfml_project

# base64 encode the zipped archive and add it to the end of the script
base64 sfml_project.tar.gz >> sfml_project

# remove the archive (we don't need it anymore)
rm sfml_project.tar.gz

# make the script executable
chmod +x sfml_project

# we're done
echo 'Script has been generated in: sfml_project'
echo ''
echo 'Install the script by copying it into your system path (eg. ~/.local/bin)'
