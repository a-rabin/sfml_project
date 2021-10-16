#!/bin/bash



echo '#####################################################################'
echo '#               VS Code: C/C++ Project Template'
echo '#                       [SFML Edition]'
echo '#                           v0.04'
echo '#                           ver 1.02'
echo '#         Original Code: Moros Smith <moros1138@gmail.com>'
echo '#  SFML Edition by AKA Rabin Studio <akarabinstudio@protonmail.com>'
echo '######################################################################'
echo ''

# find ourself so we can open ourself later
SELF="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SELF="$SELF/sfml_project"



# if we make it here, our environment is ready!

# prompt for the project name
read -p "Project Name? (default: MyApp) " project_name

# empty, at first, to keep track of which libraries to download
project_libs=""

# prompt for SFML
read -p "Use SFML? (y/n) " temp
if [ "$temp" = "y" ]; then project_libs="${project_libs} libsfml-dev"; fi


# if the project name was left empty, use MyApp as default
if [ -z "$project_name" ]; then
	project_name=MyApp
fi

echo ''
echo -n 'Generating archive....'

# create project directory
mkdir $project_name

# move into the project directory
cd $project_name

###############################################################################
# START: LOAD THE ARCHIVE FROM THE END OF THE SCRIPT
###############################################################################
# In order to simplify the creation of the project, we have added an archive
# in base64 format at the end of this script. The following mess allows us
# to load the archive, decode it, and extract it.
###############################################################################

# This finds the line number where the base64 encoded archive lies
PAYLOAD_LINE=$(awk '/^__PAYLOAD_BEGINS__/ { print NR + 1; exit 0; }' $SELF)

# This bit does a few things in one line
#
#   1.  uses tail on this script and outputs everything past the
#       __PAYLOAD_BEGINS__ marker, which we assume is a base64
#       encoded archive file.
#
#   2.  decodes the base64 data and pipes it
#
#   3.  uses tar to unzip and extract the archive

tail -n +${PAYLOAD_LINE} $SELF | base64 --decode - | tar xz

###############################################################################
# END: LOAD THE ARCHIVE FROM THE END OF THE SCRIPT
###############################################################################

echo ' done.'
echo ''


for lib in $project_libs
do

    #SFML development libraries checker


		dpkg -s "$lib" >/dev/null 2>&1 && {
			echo -e 'SFML is installed, proceeding...\n'
		} || {
			echo 'SFML is missing, please install SFML by using the following command:'
			echo '"sudo apt install libsfml-dev"'
			echo 'Program will now be closed.'
			exit 1
		}

		curl -s https://raw.githubusercontent.com/a-rabin/sfml_project/main/src/example_sfml_program.cpp -o src/main.cpp




done

echo ''
echo -n 'String replacements....'

# string replacements
sed -i "s/{{BINARY_NAME}}/$project_name/g" Makefile
sed -i "s/{{BINARY_NAME}}/$project_name/g" .gitignore
sed -i "s/{{BINARY_NAME}}/$project_name/g" .vscode/launch.json

echo ' done.'
echo ''


# prompt for Git repository
read -p "Initialize a Git Repository? (y/n) " temp
if [ "$temp" = "y" ]; then git init &> /dev/null; git add .; git commit -m "initial commit" &> /dev/null; temp=""; fi

# prompt for opening the project in VS Code
read -p "Open project in VS Code? (y/n) " temp
if [ "$temp" = "y" ]; then code .; temp=""; fi

# navigate back to the directory we came from
cd ..

# we're done!
echo "Done!"

###############################################################################
# DO NOT EDIT BEYOND THIS POINT UNLESS YOU KNOW PRECISELY WHAT YOU ARE DOING!
###############################################################################
exit 0
__PAYLOAD_BEGINS__
