@echo on
setlocal EnableDelayedExpansion

:: MSVC needs the conforming preprocessor for AMGX's macros; nvcc must reuse
:: the already-activated MSVC environment rather than locate one itself.
set "NVCC_APPEND_FLAGS=%NVCC_APPEND_FLAGS% --use-local-env -Xcompiler=/Zc:preprocessor"

cmake %CMAKE_ARGS% -S "%SRC_DIR%" -B build -G Ninja ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
  -DCMAKE_CUDA_ARCHITECTURES="%CUDAARCHS%" ^
  -DCMAKE_CXX_STANDARD=17 ^
  -DCMAKE_CUDA_RUNTIME_LIBRARY=Shared ^
  -DCMAKE_NO_MPI=ON
if errorlevel 1 exit 1

cmake --build build --parallel %CPU_COUNT%
if errorlevel 1 exit 1
cmake --install build
if errorlevel 1 exit 1

del /q "%LIBRARY_LIB%\amgx.lib"
rmdir /s /q "%LIBRARY_LIB%\examples"
