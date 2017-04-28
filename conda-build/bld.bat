set BLPAPI_ROOT="blpapi_cpp"

copy blpapi_cpp\lib\*64* "%PREFIX%"
if errorlevel 1 exit 1

"%PYTHON%" setup.py install
if errorlevel 1 exit 1