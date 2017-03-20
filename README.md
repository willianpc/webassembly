# The all new WebAssembly

## Getting started

This simple documentation is nothing more than a summary of the atual documentation, found at http://webassembly.org/getting-started/developers-guide/

My environment is a PC running Linux Mint. For details about Mac or Windows, please go to the oficial web site and check the documentation mentioend above.

## Browser compatibility

From my tests, the following browsers are currently supported:

 * Firefox 52 (Linux Mint, Windows 10, Mac and Android)
 * Google Chrome 57 (Linux Mint and Mac)

If you happen to test this in another browsers, please let me know: o.chambs@gmail.com

## Live Sample

http://williancarvalho.com/webassembly/

## Fiddle
https://wasdk.github.io/WasmFiddle/

## WASM Explorer

https://mbebenita.github.io/WasmExplorer/

## Requirements
 * Git
 * Cmake
 * Python 2.7.x
 * GCC

## Steps

### Compile Emscripten

  **Warning:** This step takes forever. If you don't have much time, don't even start this. Specially if you need to install all required tools. Seriously, it took around 3 hours to build the thing.

        $ git clone https://github.com/juj/emsdk.git
        $ cd emsdk
        $ ./emsdk install sdk-incoming-64bit binaryen-master-64bit
        $ ./emsdk activate sdk-incoming-64bit binaryen-master-64bit

### Enter an Emscripten compiler environment

        $ source ./emsdk_env.sh

### Write a C code

```c
      #include <stdio.h>

      int main (int argc, char ** argv) {
        char * hello = "Hello, Webassembly!";
        printf("%s\n", hello);
      }
```

### Compile it with emcc

        emcc hello.c -s WASM=1 -o hello.html

This command will output an HTML page, a Javascript file and a WASM file

### Start a webserver and call `hello.html`

        python -m SimpleHTTPServer

That's that!

### Being lazy

If you happen to have a very similar environment as mine, you can use my `Makefile` to do the job for you:

        $ make

This will build the 3 files into a `dist` folder.

To be even lazier, you can run

        $ make .serve_web

Which will build stuff to the `dist` folder and start the Python SimpleHTTPServer. Then go to `http://localhost:8000/dist/hello.html` to see the page.

To be extremely super lazy, just see the results at http://williancarvalho.com/webassembly/

## Doing something cooler (and more useful)

After you have been through the whole process above, your next question will probably be: "Ok, cool, now how do I write some serious function in C and use it in a 'real world' situation"?
Good question! Basically, what you need now is:

 * Create a function in C, or a set of them
 * Compile this C file into a .wasm file without the HTML and JS files
 * Inject the WASM binary into your OWN Javascript code
 * See the magic happening by your own hands!

Alright, let's go:

### Write some function

Start with something simple, like a "sum" function, or a recursive Fibonacci:

```C
      double fib (int n) {
          if (n <= 2) {
              return 1;
          }

          return fib(n - 2) + fib(n -1);
      }
```

### Compile your module

Run the following command to compile the WASM file:

      $ emcc fib.c -Os -s WASM=1 -s SIDE_MODULE=1 -o fib.wasm

You should be able to see your new `fib.wasm` file!

Note that now we have the `-Os` and `-s SIDE_MODULE=1` additional arguments. Basically, they are needed in order to:

  * Be able to build only the .wasm file without the HTML and JS files
  * Avoid an error at the time of instantiating your module

### Create your JS piece of code to read and instantiate the module

```javascript

// This object represent any libs imported by your module.
// Even though we have none, this "empty" object is needed
var imports = {
  env: {
    memoryBase: 0,
    tableBase: 0,
    memory: new WebAssembly.Memory({initial: 256}),
    table: new WebAssembly.Table({ initial: 0, element: 'anyfunc' })
  }
}

// Fetch and instantiate the module
fetch('fib.wasm')
.then(res => res.arrayBuffer())
.then(buffer => WebAssembly.instantiate(buffer, imports))
.then(myModule => {
  var exports = myModule.instance.exports;
  var result = exports._fib(10);
  console.log('fib(10) = ' + result);
});

```

### Mix everything and test it!

  * Create an HTML page and include your script
  * Run it in a web server
  * Open the browser's console and call the HTML page

If everything went fine, you should be able to see the following output in the browser's console:

      > fib(10) = 55

## Sources

I know I am not explaining a lot, but the thing is still very new, so it is hard to find content about it.
Even the tools used to generate modules are still incomplete, although I really think they are awesome!
If you really got as far as I did (and I hope this repo has helped you), you might want to know more.
So here are some interesting links:

 * Standalone Webassembly example: https://gist.github.com/kripken/59c67556dc03bb6d57052fedef1e61ab
 * About standalone webassembly: https://github.com/kripken/emscripten/wiki/WebAssembly-Standalone
 * About Webassembly in Emscripten repo: https://github.com/kripken/emscripten/wiki/WebAssembly
 * Binaryen: https://github.com/WebAssembly/binaryen
 * Webassembly advanced tools: http://webassembly.org/getting-started/advanced-tools/
 * wasdk repo: https://github.com/wasdk/wasdk
