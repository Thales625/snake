#include <iostream>

#define SIZE 10

#define CHAR_EMPTY ' '
#define CHAR_HEAD 'O'
#define CHAR_BODY '*'

typedef struct Point {
	int x;
	int y;

	Point operator+(const Point& other) const {
		Point result;
		result.x = this->x + other.x;
		result.y = this->y + other.y;
		return result;
	}

	Point& operator+=(const Point& other) {
		this->x += other.x;
		this->y += other.y;
		return *this;
	}
} Point;

char mem[SIZE][SIZE]; // Mips memory representation (screen)

Point stack[SIZE*SIZE]; 
int head_ptr;

Point apple; // maximum = every pixel is an apple
Point move; // 0 = up, 1 = right, 2 = down, 3 = left

void clear_memory() {
	for (int y = 0; y < SIZE; y++) {
		for (int x = 0; x < SIZE; x++) {
			mem[y][x] = CHAR_EMPTY;
		}
	}
}

void clear() {
	clear_memory();

	// clear stack
	for (int i = 0; i < SIZE*SIZE; i++) {
		stack[i].x = 0;
		stack[i].y = 0;
	}
}

void show_memory() { // print memory
	for (int y = 0; y < SIZE; y++) {
		for (int x = 0; x < SIZE; x++) {
			std::cout << mem[y][x];
		}
		std::cout << "\n";
	}
}

void show_stack() { // print stack
	for (int i=0; i<=head_ptr; i++) {
		std::cout << "stack[" << i << "] = (" << stack[i].x << ", " << stack[i].y << ")\n";
	}
}

void snake_to_memory() {
	// set snake head in memory
	mem[stack[head_ptr].y][stack[head_ptr].x] = CHAR_HEAD;

	// set snake in memory
	for (int i = 0; i < SIZE*SIZE; i++) {
		if (i == head_ptr) continue;
		if (stack[i].x != 0 && stack[i].y != 0) {
			mem[stack[i].y][stack[i].x] = CHAR_BODY;
		}
	}
}

void shift_stack() { // shift-left stack
	for (int i=0; i<head_ptr; i++) {
		stack[i] = stack[i+1];
	}
}

void update() {
	// update snake position
	mem[stack[0].y][stack[0].x] = CHAR_EMPTY; // clear shifted-point
	shift_stack();
	stack[head_ptr] += move;

	// update apple position
}

int main() {
	clear();

	// initialize
	apple.x = 4;
	apple.y = 4;

	stack[0].x = 1;
	stack[0].y = 1;

	stack[1].x = 2;
	stack[1].y = 1;

	stack[2].x = 3;
	stack[2].y = 1;

	head_ptr = 2;

	move.x = 1;
	move.y = 0;

	for (int t=0; t<5; t++) {
		if (t == 3) {
			move.x = 0;
			move.y = 1;
		}

		std::cout << "T"<<t<<"---move=("<<move.x<<", "<<move.y<<")---\n";

		update();

		snake_to_memory();

		show_memory();
		// show_stack();
	}

	return 0;
}