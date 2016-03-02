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
    touch ./$2/$2/__init__.py
    # rename template files
    sed -i.bak "s/NAME/$2/" ./$2/setup.py
    rm ./$2/setup.py.bak
    sed -i.bak "s/NAME/$2/" ./$2/tests/$2_test.py
    rm ./$2/tests/$2_test.py.bak
    # setup a virtualenv
    virtualenv ./virtualenvs/$2
else
    echo 'Unknown, skipping tests files'
fi

# create readme
touch ./$2/README.md

# setup git
git init ./$2/
cp ./scripts/skeletons/$1/gitignore ./$2/.gitignore
cat ./scripts/skeletons/$1/config >> ./$2/.git/config
sed -i.bak "s/NAME/$2/" ./$2/.git/config
rm ./$2/.git/config.bak

# setup travis & coveralls
cp ./scripts/skeletons/$1/travis.yml ./$2/.travis.yml
sed -i.bak "s/NAME/$2/" ./$2/.travis.yml
rm ./$2/.travis.yml.bak
