#include <stdio.h>

#define SIZE 10

#define CHAR_EMPTY ' '
#define CHAR_HEAD 'O'
#define CHAR_BODY '*'
#define CHAR_APPLE 'a'

char mem[SIZE][SIZE]; // Mips memory representation (screen)

int stack[2*SIZE*SIZE]; 
int head_ptr;

int head_next_x;
int head_next_y;

int apple_x; // maximum = every pixel is an apple
int apple_y;

int move_x;
int move_y;

void clear() {
	// clear memory
	for (int y = 0; y < SIZE; y++) {
		for (int x = 0; x < SIZE; x++) {
			mem[y][x] = CHAR_EMPTY;
		}
	}

	// clear stack
	for (int i = 0; i < 2*SIZE*SIZE; i++) {
		stack[i] = -1;
	}
}

void show_memory() { // print memory
	for (int y = 0; y < SIZE; y++) {
		for (int x = 0; x < SIZE; x++) {
			printf("%c", mem[y][x]);
		}
		printf("\n");
	}
}

void show_stack() { // print stack
	for (int i=0; i<=2*head_ptr; i+=2) {
		printf("stack[%d] = (%d, %d)\n", i, stack[i], stack[i+1]);
	}
}

void shift_stack() { // shift-left stack
	for (int i=0; i<2*head_ptr; i+=2) {
		stack[i] = stack[i+2];
		stack[i+1] = stack[i+3];
	}
}

void update() {
	head_next_x = stack[2*head_ptr] + move_x;
	head_next_y = stack[2*head_ptr+1] + move_y;

	// check collision with the apple
	if (apple_x == head_next_x && apple_y == head_next_y) { // case: collide with the apple
		head_ptr += 1;

		// it is not necessary to clear the apple from memory, as it will be overwritten by the snake's head
		// update apple position
		apple_x = 1;
		apple_y = 6;
	} else { // case: didnt collide with the apple
		mem[stack[1]][stack[0]] = CHAR_EMPTY; // clear shifted point
		shift_stack();
	}

	stack[2*head_ptr] = head_next_x;
	stack[2*head_ptr+1] = head_next_y;
}

void setup_memory() {
	// set snake head in memory
	// mem[stack[2*head_ptr+1]][stack[2*head_ptr]] = CHAR_HEAD;
	mem[head_next_y][head_next_x] = CHAR_HEAD;

	// set snake body in memory
	for (int i=0; i<2*head_ptr; i+=2) {
		if (stack[i] != -1 && stack[i+1] != -1) {
			mem[stack[i+1]][stack[i]] = CHAR_BODY;
		}
	}

	// apple
	mem[apple_y][apple_x] = CHAR_APPLE;
}

int main() {
	clear();

	// initialize
	apple_x = 6;
	apple_y = 1;

	stack[0] = 1;
	stack[1] = 1;

	stack[2] = 2;
	stack[3] = 1;

	stack[4] = 3;
	stack[5] = 1;

	head_ptr = 2;

	move_x = 1;
	move_y = 0;

	for (int t=0; t<7; t++) {
		if (t == 3) {
			move_x = 0;
			move_y = 1;
		}

		printf("T%d---move=(%d, %d)---\n", t, move_x, move_y);

		update();

		setup_memory();

		show_memory();
	}

	return 0;
}