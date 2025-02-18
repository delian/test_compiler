conan remote update conancenter --url https://center2.conan.io
conan profile detect
cmake -S . -B build -G Ninja
cmake --build build -v --clean-first -j 8
