cmake_minimum_required(VERSION 3.16)
project(wavelet2d)

enable_testing()

# Set up language settings
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS NO)

# Find Halide
find_package(Halide REQUIRED)

# Generator
add_executable(wavelet2d.generator
               daubechies_generator.cpp
               inverse_daubechies_generator.cpp
               haar_generator.cpp
               inverse_haar_generator.cpp)
target_link_libraries(wavelet2d.generator PRIVATE Halide::Generator)

# Filters
add_halide_library(daubechies FROM wavelet2d.generator)
add_halide_library(inverse_daubechies FROM wavelet2d.generator)
add_halide_library(haar FROM wavelet2d.generator)
add_halide_library(inverse_haar FROM wavelet2d.generator)

# Main executable
add_executable(wavelet2d wavelet2d.cpp)
target_link_libraries(wavelet2d
                      PRIVATE
                      Halide::Halide
                      Halide::ImageIO
                      daubechies
                      inverse_daubechies
                      haar
                      inverse_haar)

# Test that the app actually works!
set(IMAGE ${CMAKE_CURRENT_LIST_DIR}/../images/gray.png)
if (EXISTS ${IMAGE})
    configure_file(${IMAGE} gray.png COPYONLY)
    add_test(NAME wavelet2d COMMAND wavelet2d gray.png .)
    set_tests_properties(wavelet2d PROPERTIES
                         LABELS wavelet2d
                         PASS_REGULAR_EXPRESSION "Success!"
                         SKIP_REGULAR_EXPRESSION "\\[SKIP\\]")
endif ()
