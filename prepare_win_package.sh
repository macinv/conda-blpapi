#!/usr/bin/env bash
# script to build and upload the blpapi conda package.

set -e

# make package dir
mkdir ${PKG_DIR}

# set meta.yaml programmatically
sed -i "/  version:/c\  version: \"${BLPAPI_VERSION}\"" conda-build/meta.yaml
sed -i "/  summary: Python/c\  summary: Python SDK for Bloomberg BLPAPI (with C++ ${BLPAPI_CPP_VERSION} binary included)" conda-build/meta.yaml
cat conda-build/meta.yaml

# copy the conda build files into the package directory
cp conda-build/* ${PKG_DIR}/

cd ${PKG_DIR}

# unpack the tar files into the appropriate locations
mkdir src
mv BLPAPI_LICENSE src/BLPAPI_LICENSE
mkdir src/blpapi_cpp

cd src
unzip ../../blpapi_python*.zip && mv blpapi-${BLPAPI_VERSION}/* . && rmdir blpapi-${BLPAPI_VERSION}
unzip ../../blpapi_cpp*.zip  -d blpapi_cpp && mv blpapi_cpp/*/* blpapi_cpp/ && rmdir blpapi_cpp/blpapi_cpp_${BLPAPI_CPP_VERSION}
rm blpapi_cpp/bin/*.exe
rm -rf blpapi_cpp/examples
rm -rf blpapi_cpp/doc
rm -rf blpapi_cpp/blpapi_cpp_${BLPAPI_CPP_VERSION}
cd ../..;

mkdir ${BUILD_DIR}
