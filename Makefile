CC=emcc
OUTPUT_FOLDER=./dist
OUTPUT=$(OUTPUT_FOLDER)/hello.html
DISTDIR=dist

build: .clear .build_fib
	$(CC) hello.c -s WASM=1 -o $(OUTPUT)

.copy_files:
	cp _index.html ./dist/index.html

.clear:
	rm -f $(DISTDIR)/*

.serve_web: build .copy_files
	python -m SimpleHTTPServer

.build_fib:
	$(CC) fib.c -Os -s WASM=1 -s SIDE_MODULE=1 -o $(OUTPUT_FOLDER)/fib.wasm 