CC=emcc
OUTPUT=./dist/hello.html
DISTDIR=dist

build: .clear hello.c
	$(CC) hello.c -s WASM=1 -o $(OUTPUT) && mv $(DISTDIR)/hello.html $(DISTDIR)/index.html

.clear:
	rm -f $(DISTDIR)/*

.serve_web: build
	python -m SimpleHTTPServer