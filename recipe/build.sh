#! /usr/bin/bash

mkdir build
cd build

# ${CMAKE_ARGS} carries conda-build's own -DCMAKE_BUILD_TYPE=Release
# (plus toolchain/strip paths) -- omitting it leaves CMAKE_BUILD_TYPE
# unset (this project's own CMakeLists.txt never defaults it either),
# producing an unoptimized, unstripped debug-info binary.
# pybind11 in the build env brings its own (newer) Python, which CMake
# would find first; build against the host Python instead.
cmake .. ${CMAKE_ARGS} -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DPython_EXECUTABLE="${PYTHON}" -DPython3_EXECUTABLE="${PYTHON}"

NPROC=$(nproc 2>/dev/null || sysctl -n hw.ncpu)
make -j$NPROC
make install
