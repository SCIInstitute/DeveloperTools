set(CTEST_SOURCE_DIRECTORY "C:/Users/Brig/Documents/Cleaver2/src")
set(CTEST_BINARY_DIRECTORY "C:/Users/Brig/Documents/Cleaver2/build")
SET(CTEST_CMAKE_COMMAND "C:/CMake2.8/bin/cmake.exe")
SET(CTEST_COMMAND "C:/CMake2.8/bin/ctest.exe -D Nightly")
SET (CTEST_INITIAL_CACHE "
    MAKECOMMAND:STRING=nmake
    CMAKE_MAKE_PROGRAM:FILEPATH=nmake
    ")
SET (CTEST_START_WITH_EMPTY_BINARY_DIRECTORY TRUE)
SET (CTEST_ENVIRONMENT "")


set(CTEST_SITE "IMAC-PC")
set(CTEST_BUILD_NAME "Win64-nmake")

set(SCIRUN_PATH "C:/SCIRun4-binary")

set(CTEST_CMAKE_GENERATOR "NMake Makefiles")
set(CTEST_BUILD_CONFIGURATION "Debug")
set(CTEST_BUILD_OPTIONS 
  "-DITK_DIR:FILEPATH=C:/ITK-4.7.2/msvc2015 -DBUILD_FULL_CLEAVER:BOOL=TRUE -Wno-dev --DQt5Core_DIR=C:/Qt5Installer/5.6/msvc2015_64/lib/cmake/Qt5Widgets -DQt5Gui_DIR=C:/Qt5Installer/5.6/msvc2015_64/lib/cmake/Qt5Gui  -DQt5OpenGL_DIR=C:/Qt5Installer/5.6/msvc2013_64/lib/cmake/Qt5OpenGL  -DQt5Widgets_DIR=C:/Qt5Installer/5.6/msvc2015_64/lib/cmake/Qt5Widgets -Dgtest_build_tests:BOOL=FALSE -DUSE_GCOV:BOOL=OFF -Dgtest_force_shared_crt:BOOL=ON -DSCIRun4_DIR:PATH=${SCIRUN_PATH} -DBZ2_FOUND:BOOL=ON -DBZ2_LIBRARY:FILEPATH=C:/bzip2/lib/libbz2.lib -DBZ2_INCLUDE_DIR:PATH=C:/bzip2/include -DTeem_BZIP2:BOOL=ON -DZLIB_FOUND:BOOL=ON -DZLIB_LIBRARY:FILEPATH=C:/zlib/build/zlib.lib -DZLIB_INCLUDE_DIR:PATH=C:/zlib/build -DTeem_ZLIB:BOOL=ON"
)
set(WITH_MEMCHECK FALSE)
set(WITH_COVERAGE FALSE)

################################################################## How to schedule in Windows: Basic task daily, admin priv., 
# and run logged on or not. 
# program : C:\Windows\System32\cmd.exe
# arguments : /k ""C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat"" amd64 && C:\CMake2.8\bin\ctest.exe -S Eikonal.cmake -VV > Eikonal.log 2>&1
# starting dir : C:\Users\Brig\Documents\CDashScripts
#################################################################
# how to schedule in unix : crontab -e
# 0 3 * * * /usr/local/bin/ctest -S ~/CDashScripts/Eikonal.cmake -VV > ~/CDashScripts/Eikonal.log 2>&1
#################################################################

ctest_empty_binary_directory(${CTEST_BINARY_DIRECTORY})

find_program(CTEST_GIT_COMMAND NAMES git)
#find_program(CTEST_COVERAGE_COMMAND NAMES gcov)
#find_program(CTEST_MEMORYCHECK_COMMAND NAMES valgrind)

#set(CTEST_MEMORYCHECK_SUPPRESSIONS_FILE ${CTEST_SOURCE_DIRECTORY}/tests/valgrind.supp)

if(NOT EXISTS "${CTEST_SOURCE_DIRECTORY}")
set(CTEST_CHECKOUT_COMMAND "${CTEST_GIT_COMMAND} clone git@github.com:SCIInstitute/Cleaver2.git ${CTEST_SOURCE_DIRECTORY}")
endif()

set(CTEST_UPDATE_COMMAND "${CTEST_GIT_COMMAND}")

set(CTEST_CONFIGURE_COMMAND "${CMAKE_COMMAND} -DCMAKE_BUILD_TYPE:STRING=${CTEST_BUILD_CONFIGURATION}")
set(CTEST_CONFIGURE_COMMAND "${CTEST_CONFIGURE_COMMAND} -DBUILD_TESTING:BOOL=ON ${CTEST_BUILD_OPTIONS}")
set(CTEST_CONFIGURE_COMMAND "${CTEST_CONFIGURE_COMMAND} \"-G${CTEST_CMAKE_GENERATOR}\"")
set(CTEST_CONFIGURE_COMMAND "${CTEST_CONFIGURE_COMMAND} \"${CTEST_SOURCE_DIRECTORY}\"")

ctest_start("Nightly")
ctest_update()
ctest_configure()
ctest_build()
ctest_test()
if (WITH_COVERAGE AND CTEST_COVERAGE_COMMAND)
ctest_coverage()
endif (WITH_COVERAGE AND CTEST_COVERAGE_COMMAND)
if (WITH_MEMCHECK AND CTEST_MEMORYCHECK_COMMAND)
ctest_memcheck()
endif (WITH_MEMCHECK AND CTEST_MEMORYCHECK_COMMAND)
ctest_submit()
