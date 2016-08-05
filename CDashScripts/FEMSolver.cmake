set(CTEST_SOURCE_DIRECTORY "$ENV{HOME}/FEM_Solver/src")
set(CTEST_BINARY_DIRECTORY "$ENV{HOME}/FEM_Solver/build")
SET(CTEST_CMAKE_COMMAND "/usr/bin/cmake")
SET(CTEST_COMMAND "/usr/local/bin/ctest -D Nightly")
SET (CTEST_INITIAL_CACHE "
MAKECOMMAND:STRING=make -j12
CMAKE_MAKE_PROGRAM:FILEPATH=make
")
SET (CTEST_START_WITH_EMPTY_BINARY_DIRECTORY TRUE)
SET (CTEST_ENVIRONMENT
   "PATH=/usr/lib64/mpi/gcc/openmpi/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/X11R6/bin:/usr/games:/usr/lib/mit/bin:/usr/lib/mit/sbin")

set(CTEST_SITE "cibc-test6.sci.utah.edu")
set(CTEST_BUILD_NAME "OpenSuse13.1_NVIDIA_GTX680HD")

set(CTEST_CMAKE_GENERATOR "Unix Makefiles")
set(CTEST_BUILD_CONFIGURATION "Debug")
set(CTEST_BUILD_OPTIONS "-DUSE_GCOV:BOOL=ON -DBUILD_EXAMPLES:BOOL=ON")

set(WITH_MEMCHECK TRUE)
set(WITH_COVERAGE TRUE)

#######################################################################
# How to schedule in Windows: Basic task daily, admin priv., 
# and run logged on or not. 
# program : C:\Windows\System32\cmd.exe
# arguments : /k ""C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat"" amd64 && C:\CMake\bin\ctest.exe -S Eikonal.cmake -VV > Eikonal.log 2>&1
# starting dir : C:\Users\Brig\Documents\CDashScripts
#################################################################
# how to schedule in unix : crontab -e
# 0 3 * * * /usr/local/bin/ctest -S ~/CDashScripts/Eikonal.cmake -VV > ~/CDashScripts/Eikonal.log 2>&1
#################################################################

ctest_empty_binary_directory(${CTEST_BINARY_DIRECTORY})

find_program(CTEST_GIT_COMMAND NAMES git)
find_program(CTEST_COVERAGE_COMMAND NAMES gcov)
find_program(CTEST_MEMORYCHECK_COMMAND NAMES valgrind)

#set(CTEST_MEMORYCHECK_SUPPRESSIONS_FILE ${CTEST_SOURCE_DIRECTORY}/tests/valgrind.supp)

if(NOT EXISTS "${CTEST_SOURCE_DIRECTORY}")
   set(CTEST_CHECKOUT_COMMAND "${CTEST_GIT_COMMAND} clone git@github.com:SCIInstitute/SCI-Solver_FEM.git ${CTEST_SOURCE_DIRECTORY}")
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
