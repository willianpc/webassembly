CC=emcc
OUTPUT=./dist/hello.html
DISTDIR=dist

build: .clear hello.c
	$(CC) hello.c -s WASM=1 -o $(OUTPUT)

.clear:
	rm -f $(DISTDIR)/*

.serve_web: build
	python -m SimpleHTTPServer