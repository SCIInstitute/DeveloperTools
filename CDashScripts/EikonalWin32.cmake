set(CTEST_SOURCE_DIRECTORY "C:/Users/Brig/Documents/Eikonal_Solver/src")
set(CTEST_BINARY_DIRECTORY "C:/Users/Brig/Documents/Eikonal_Solver/build")
SET(CTEST_CMAKE_COMMAND "C:/CMake/bin/cmake.exe")
SET(CTEST_COMMAND "C:/CMake/bin/ctest.exe -D Nightly")
SET (CTEST_INITIAL_CACHE "
    MAKECOMMAND:STRING=nmake
    CMAKE_MAKE_PROGRAM:FILEPATH=nmake
    ")
SET (CTEST_START_WITH_EMPTY_BINARY_DIRECTORY TRUE)

set(CTEST_SITE "IMAC-PC")
set(CTEST_BUILD_NAME "Win64-nmake_NVIDIA_GTX775M")

set(CTEST_CMAKE_GENERATOR "NMake Makefiles")
set(CTEST_BUILD_CONFIGURATION "Debug")
set(CTEST_BUILD_OPTIONS 
  "-DUSE_GCOV:BOOL=OFF -DBUILD_EXAMPLES:BOOL=ON -Wno-dev"
)

#################################################################
# How to schedule in Windows: Basic task daily, admin priv., 
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

if(NOT EXISTS "${CTEST_SOURCE_DIRECTORY}")
set(CTEST_CHECKOUT_COMMAND "${CTEST_GIT_COMMAND} clone git@github.com:SCIInstitute/SCI-Solver_Eikonal.git ${CTEST_SOURCE_DIRECTORY}")
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
ctest_submit()
