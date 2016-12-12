#!/bin/bash

# needed for building
export BLPAPI_ROOT="blpapi_cpp"

# do the build
$PYTHON setup.py install

# hack to store the C++ library
cp -v $BLPAPI_ROOT/Linux/lib*.so $PREFIX/lib/
