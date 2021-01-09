#!/bin/sh

cd ~/Source/halide_build
mkdir apps
cmake -DCMAKE_BUILD_TYPE=Release -DLLVM_DIR=/usr/lib64/cmake/llvm -DCMAKE_MODULE_PATH=~/.local/git/Halide/cmake/Modules ~/.local/git/Halide/
make all -j`nproc`
cmake --install . --prefix ./_Halide_install
cd apps
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_MODULE_PATH=~/.local/git/Halide/cmake/Modules -DCMAKE_PREFIX_PATH=~/Source/halide_build/_Halide_install -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda ~/.local/git/Halide/apps
