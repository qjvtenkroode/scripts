#!/bin/sh

PROJECTS_DIR=$3

# create directories
mkdir $PROJECTS_DIR/$2/
mkdir $PROJECTS_DIR/$2/$2
mkdir $PROJECTS_DIR/$2/bin
mkdir $PROJECTS_DIR/$2/docs
mkdir $PROJECTS_DIR/$2/tests

# copy template files
cp $PROJECTS_DIR/scripts/skeletons/$1/NAME_tests.py $PROJECTS_DIR/$2/tests/$2_tests.py
cp $PROJECTS_DIR/scripts/skeletons/$1/setup.py $PROJECTS_DIR/$2/
touch $PROJECTS_DIR/$2/README.md
touch $PROJECTS_DIR/$2/$2/__init__.py
touch $PROJECTS_DIR/$2/tests/__init__.py

# rename template files
sed -i.bak "s/NAME/$2/" $PROJECTS_DIR/$2/setup.py
rm $PROJECTS_DIR/$2/setup.py.bak
sed -i.bak "s/NAME/$2/" $PROJECTS_DIR/$2/tests/$2_tests.py
rm $PROJECTS_DIR/$2/tests/$2_tests.py.bak

# setup git
git init $PROJECTS_DIR/$2/
cp $PROJECTS_DIR/scripts/skeletons/$1/gitignore $PROJECTS_DIR/$2/.gitignore
cat $PROJECTS_DIR/scripts/skeletons/$1/config >> $PROJECTS_DIR/$2/.git/config
sed -i.bak "s/NAME/$2/" $PROJECTS_DIR/$2/.git/config
rm $PROJECTS_DIR/$2/.git/config.bak
