conan profile detect
cmake -S . -B build -G Ninja
cmake --build build -v --clean-first -j 8
