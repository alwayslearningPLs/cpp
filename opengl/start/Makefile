build: main.cpp
	@g++ -std=c++11 -c main.cpp -Iinclude -obin/main.o

link: bin/main.o
	@g++ bin/main.o bin/glad.o -o bin/a.out -lGL -lGLU -lglfw3 -lX11 -lXxf86vm -lXrandr -lpthread -lXi -ldl -lXinerama -lXcursor

run: bin/a.out
	bin/a.out

clean:
	@rm bin/main.o
	@rm bin/a.out

all: build link run

