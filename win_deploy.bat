anaconda login --user %CONDA_USER% --password %CONDA_PASSWORD%
anaconda upload --force %BUILD_DIR%\win-64\*.tar.bz2
anaconda logout
