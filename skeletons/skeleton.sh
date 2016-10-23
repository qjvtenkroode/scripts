#!/bin/sh

# create directories
mkdir ./$2/
mkdir ./$2/$2
mkdir ./$2/bin
mkdir ./$2/docs
mkdir ./$2/tests

if [ $1 = 'python' ]; then
    # copy template files
    cp ./scripts/skeletons/$1/NAME_test.py ./$2/tests/$2_test.py
    cp ./scripts/skeletons/$1/setup.py ./$2/
    cp ./scripts/skeletons/$1/Makefile ./$2/
    cp ./scripts/skeletons/$1/dev_requirements.txt ./$2/
    touch ./$2/$2/__init__.py
    touch ./$2/$2/$2.py
    # rename template files
    sed -i.bak "s/NAME/$2/g" ./$2/setup.py
    rm ./$2/setup.py.bak
    sed -i.bak "s/NAME/$2/g" ./$2/Makefile
    rm ./$2/Makefile.bak
    sed -i.bak "s/NAME/$2/g" ./$2/tests/$2_test.py
    rm ./$2/tests/$2_test.py.bak
    # setup a virtualenv
    cd ./$2 && make bootstrap-dev && cd ../
else
    echo 'Unknown, skipping tests files'
fi

# create readme
touch ./$2/README.md

# setup git
git init ./$2/
cp ./scripts/skeletons/$1/gitignore ./$2/.gitignore
cat ./scripts/skeletons/$1/config >> ./$2/.git/config
sed -i.bak "s/NAME/$2/g" ./$2/.git/config
rm ./$2/.git/config.bak

# setup travis
cp ./scripts/skeletons/$1/travis.yml ./$2/.travis.yml
sed -i.bak "s/NAME/$2/g" ./$2/.travis.yml
rm ./$2/.travis.yml.bak
