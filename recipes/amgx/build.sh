#!/usr/bin/env bash
set -euxo pipefail

# CUDAARCHS is exported by conda-forge's cuda-nvcc activation with the
# architectures the pinned toolkit supports. AMGX otherwise defaults to
# "90;100;120", which excludes every GPU older than Hopper.
cmake ${CMAKE_ARGS} -S "${SRC_DIR}" -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_CUDA_ARCHITECTURES="${CUDAARCHS}" \
  -DCMAKE_CXX_STANDARD=17 \
  -DCMAKE_CUDA_RUNTIME_LIBRARY=Shared \
  -DCMAKE_NO_MPI=ON \
  -DAMGX_NO_RPATH=OFF

cmake --build build --parallel "${CPU_COUNT}"
cmake --install build

# The static archive and the example binaries are built from the same objects
# but are not part of this package.
rm -f "${PREFIX}/lib/libamgx.a"
rm -rf "${PREFIX}/lib/examples"
