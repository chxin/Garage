cmake_minimum_required(VERSION 3.5)

#############################################
# Set the project name
project (cpp-demo)

#############################################
# Add an library for the example classes
add_library(example
    src/demo.cpp
)

target_include_directories(example
  PUBLIC
  ${PROJECT_SOURCE_DIR}/include
)
#############################################
# Unit tests

add_subdirectory(include/google-test)

# enable CTest testing
enable_testing()

#############################################
# Add a executable
add_executable(main example/demo/main.cpp)
add_executable(unit_tests test/unit-tests.cpp)

target_link_libraries(unit_tests
    example
    GTest::GTest
    GTest::Main
)

#############################################
# Add a test
add_test(test_all unit_tests)
