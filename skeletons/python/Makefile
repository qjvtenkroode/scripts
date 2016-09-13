.PHONY: clean clean-pyc
VENV=~/playground//virtualenvs/NAME

help:
	@echo "Help me!"
	@echo "\t bootstrap - create a virtualenv and install the required packages."
	@echo "\t bootstrap-dev - create a virtualenv and install the required packages for development."
	@echo "\t clean - cleans everything, using clean-pyc"
	@echo "\t clean-pyc - remove python artifacts"
	@echo "\t test - run all tests"
	@echo "\t test-flake8 - run flake8 tests"
	@echo "\t test-pytest - run pytest tests"

$(VENV)/bin/pip:
	virtualenv $(VENV)

bootstrap: $(VENV)/bin/pip
	$(VENV)/bin/pip install -r requirements.txt

bootstrap-dev: $(VENV)/bin/pip
	$(VENV)/bin/pip install -r dev_requirements.txt

clean: clean-pyc

clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -rf {} +

test: test-pytest test-flake8

test-flake8:
	@echo "Running flake8:\n"
	$(VENV)/bin/flake8 --ignore='E501' ./NAME
	@echo "\n"

test-pytest:
	@echo "Running pytest:\n"
	PYTHONPATH=./NAME $(VENV)/bin/py.test --cov=NAME --cov-report term-missing
	@echo "\n"
