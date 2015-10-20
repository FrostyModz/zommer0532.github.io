#!/bin/bash
dpkg-scanpackages . /dev/null > Packages
bz2 -fks Packages
