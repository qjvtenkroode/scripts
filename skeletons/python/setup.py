import sys
import os

try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

setup(
    description = 'NAME',
    author = 'Quincey ten Kroode',
    url = 'URL to get it at.',
    download_url = 'Where to download it.',
    author_email = 'qjv.tenkroode@gmail.com',
    version = '0.1',
    install_requires = [],
    packages = ['NAME'],
    scripts = [],
    name = 'NAME')

if sys.argv[-1] == 'test':
    test_requirements = [
        'pytest',
        'coverage'
    ]
    try:
        modules = map(__import__, test_requirements)
    except ImportError as e:
        err_msg = e.message.replace("No module named ", "")
        msg = "%s is not installed. Install your test requirments." % err_msg
        raise ImportError(msg)
    os.system('py.test --cov=NAME')
    sys.exit()
