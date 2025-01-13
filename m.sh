rm -rf ./build
mkdir -p build
conan install . --output-folder=build --build=missing
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake
cmake --build . --config Release
