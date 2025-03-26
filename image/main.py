from PIL import Image
import os

directory = os.path.dirname(os.path.abspath(__file__))

for filename in os.listdir(directory):
	if filename.endswith('.png'):
		img_path = os.path.join(directory, filename)
		asm_path = os.path.join(directory, f'{os.path.splitext(filename)[0]}.asm')

		with Image.open(img_path) as img:
			print(img_path)

			img = img.resize((64, 64))
			
			img = img.transpose(Image.ROTATE_90)
			img = img.transpose(Image.FLIP_LEFT_RIGHT)

			pixels = []

			for x in range(img.width):
				for y in range(img.height):
					pixel = img.getpixel((x, y))

					if isinstance(pixel, tuple):
						pixels.append(f'0x00{pixel[0]:02X}{pixel[1]:02X}{pixel[2]:02X}')
					else:
						print("Image is not in multi-layer colors")
						exit()

			with open(asm_path, 'w') as f:
				f.write(".word " + ",".join(pixels[::-1]))