#!/usr/bin/env bash
# script to build and upload the blpapi conda package.

set -e

PKG_DIR=blpapi
BUILD_DIR=build
BLPAPI_VERSION=3.5.5
BLPAPI_CPP_VERSION=3.8.18.1

wget https://bloomberg.bintray.com/BLPAPI-Stable-Generic/blpapi_python_${BLPAPI_VERSION}.tar.gz
wget https://bloomberg.bintray.com/BLPAPI-Stable-Generic/blpapi_cpp_${BLPAPI_CPP_VERSION}-linux.tar.gz

# make package dir
mkdir ${PKG_DIR}

# set meta.yaml programmatically
sed -i "/  version:/c\  version: \"${BLPAPI_VERSION}\"" conda-build/meta.yaml
sed -i "/  summary: Python/c\  Python SDK for Bloomberg BLPAPI (with C++ ${BLPAPI_CPP_VERSION} binary included)" conda-build/meta.yaml
cat conda-build/meta.yaml

# copy the conda build files into the package directory
cp conda-build/* ${PKG_DIR}/

cd ${PKG_DIR}

# unpack the tar files into the appropriate locations
mkdir src
mv BLPAPI_LICENSE src/BLPAPI_LICENSE
mkdir src/blpapi_cpp

if [[ "$TRAVIS_PYTHON_VERSION" == "2.7" ]]; then
    tar xvf ../blpapi_python_*.tar.gz -C src --strip-components=1
else
    git clone --depth=1 --branch=master https://github.com/macinv/blpapi-py.git blpapi-py
    rm -rf !$/.git
    cp -r blpapi-py/* src
fi

tar xvf ../blpapi_cpp_*.tar.gz -C src/blpapi_cpp --strip-components=1

cd ..

# make the conda package, but do not install
mkdir ${BUILD_DIR}
conda build ${PKG_DIR} --output-folder ${BUILD_DIR}

# upload the package
anaconda login --user ${CONDA_USER} --password ${CONDA_PASSWORD}
anaconda upload --force ${BUILD_DIR}/*.tar.bz2
anaconda logout
