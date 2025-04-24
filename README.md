# How to use this boilerplate

## Installation

There are three ways to work or install this app:

### VSCode DevContainer

Using VSCode devcontainer (requires only docker pre-installed and vscode with devcontainer extensions enabled) - then open the project and do CTRL+SHIFT+P in vscode and then type *devcontainer open in container* and this shall reopen the environment in container mode with all the dependencies automatically installed.
You could also enable the recommended extensions (added in the .vscode folder)

### NIX Flake

This requires **NIX** package manager preinstalled (however works on OSX and any Linux OS and in containers) and ``nix flake check`` and ``nix build`` should download the dependencies and build it and then ``nix shell`` should enter into a virtual environment with the package dependencies pre-installed from where any IDE could be used. BTW - this is the only simple way to compile LLVM with conan in debug mode on a computer with less than 64GB RAM!

### RAW

In this mode you need to have the dependencies preinstalled (manually) in order to work on this project.
The dependencies you shall ensure you have are:

* **clang**
* **conan** (>=2.0)
* **cmake**
* **gnumake**
* **ninja** (optional)
* **git**
* **clang** or **gcc/g++** (clang preferrably due to llvm dependency on it)
* **gdb**
* **flex**
* **bison**bison
* **python3**+
* **libc** with dev headers (as conan dependencies doesn't provide libc as part of the package dependencies and you shall ensure this is available )
* **readelf** (optional)
* **objdump** (optional)
* **strip** (optional)
* **llvm-tools** (optional, they are not needed for the compilation as conan will download llvm as dependency but they might be needed to troubleshoot the compilation output)

The rest of the dependencies (libraries) will be download by **conan** itself

Example installation of the dependencies needed on Ubuntu:

    sudo apt update && \
    sudo apt upgrade -y && \
    sudo apt install -y cmake ninja-build python3-pip build-essential bison flex gdb elfutils binutils && \
    sudo pip install conan && \
    conan profile detect

## Structure of the code

Everything is orchestrated with cmake including the conan. Conan shall be available, but not used directly - cmake uses conan, creates conan files, downloads dependencies.

We have all the code split into sections per function into own set of subdirectories. Every subdirectory provides one function, own (conan and internal) dependencies, produces own artifact which is then merged into one in the upstream global cmakelists.txt

* ``src/conan`` contain the conan init and shared component for all the rest of the cmake but doesnt produce artifact nor installs conan dependencies on its own
* ``src/compiler`` contains the compiler code, conan (llvm) dependencies for it and so
* ``src/parser`` contains the parser, lexer, all the artifacts related to it - dependencies (aka readline) will be installed by conan automatically there
* ``src/tests`` contains the tests, the conan dependencies (google test suite) related to the tests
* ``build`` where the build artifacts will be stored
* ``m.sh`` build the app the first time 


## Build the app for the first time

An easy way to do the build for the first time is just to execute ``bash -x ./m.sh`` or ``. ./m.sh`` in the root directory.

Or you could manually execute:

    conan remote update conancenter --url https://center2.conan.io
    conan profile detect
    rm -rf ./build
    cmake -S . -B build -G Ninja
    cmake --build build -v --clean-first -j 8

To generate tags for vim/nvim if that is your prefered editor, run ``cd build; cmake --build . --target tags``

## Run tests

To run the tests do ``cd build; ctest`` or ``cd build; ninja test`` (assuming ninja is chosen as builder, otherwise replace with ``make test``) or ``cmake --build . --target test``.
Tests are verifying the parsing of the toy language examples in the ``lang-tests`` directory.

