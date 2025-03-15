#include <iostream>

#define SIZE 10

#define CHAR_EMPTY ' '
#define CHAR_HEAD 'O'
#define CHAR_BODY '*'
#define CHAR_APPLE 'a'

struct Point {
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
};

char mem[SIZE][SIZE]; // Mips memory representation (screen)

Point stack[SIZE*SIZE]; 
int head_ptr;

Point head_next;

Point apple; // maximum = every pixel is an apple
Point move; // 0 = up, 1 = right, 2 = down, 3 = left

void clear() {
	// clear memory
	for (int y = 0; y < SIZE; y++) {
		for (int x = 0; x < SIZE; x++) {
			mem[y][x] = CHAR_EMPTY;
		}
	}

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

void setup_memory() {
	// set snake head in memory
	mem[stack[head_ptr].y][stack[head_ptr].x] = CHAR_HEAD;

	// set snake body in memory
	for (int i=0; i<head_ptr; i++) {
		if (stack[i].x != 0 && stack[i].y != 0) {
			mem[stack[i].y][stack[i].x] = CHAR_BODY;
		}
	}

	// apple
	mem[apple.y][apple.x] = CHAR_APPLE;
}

void shift_stack() { // shift-left stack
	for (int i=0; i<head_ptr; i++) {
		stack[i] = stack[i+1];
	}
}

void update() {
	head_next = stack[head_ptr] + move;

	// check collision with the apple
	if (apple.x == head_next.x && apple.y == head_next.y) { // case: collide with the apple
		head_ptr += 1;

		// it is not necessary to clear the apple from memory, as it will be overwritten by the snake's head
		// update apple position
		apple.x = 1;
		apple.y = 6;
	} else { // case: didnt collide with the apple
		mem[stack[0].y][stack[0].x] = CHAR_EMPTY; // clear shifted point
		shift_stack();
	}

	stack[head_ptr] = head_next;
}

int main() {
	clear();

	// initialize
	apple.x = 6;
	apple.y = 1;

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

		setup_memory();

		show_memory();
	}

	return 0;
}