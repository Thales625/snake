# Snake Game in MIPS

This is a simple implementation of the classic Snake game written in MIPS assembly. The game can be executed using the [MARS MIPS simulator](https://computerscience.missouristate.edu/mars-mips-simulator.htm).

## Bitmap Display Configuration

To run the Snake game, you need to configure the Bitmap Display plugin in the MARS MIPS simulator. Below are the required settings:

- **Unit Width**: 8  
- **Unit Height**: 8  
- **Display Width**: 512  
- **Display Height**: 512  
- **Base Address**: `0x10010000` (static data)

Additionally, make sure to enable the Keyboard and Display MMIO Simulator plugin to handle user input during the game.

Enjoy playing!