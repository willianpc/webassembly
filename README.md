# webassembly
playing with webassembly

## Getting started

http://webassembly.org/getting-started/developers-guide/

## Requirements
 * Git
 * Cmake
 * Python 2.7.x
 * GCC

## Steps

### Compile Emscripten

  **Warning:** This step takes forever. If you don't have much time, don't even start this. Specially if you need to install all required tools.

        $ git clone https://github.com/juj/emsdk.git
        $ cd emsdk
        $ ./emsdk install sdk-incoming-64bit binaryen-master-64bit
        $ ./emsdk activate sdk-incoming-64bit binaryen-master-64bit

### Enter an Emscripten compiler environment

        $ source ./emsdk_env.sh