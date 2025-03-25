from PIL import Image
import PIL
import os

directory = os.path.dirname(os.path.abspath(__file__))

for filename in os.listdir(directory):
	if filename.endswith('.png'):
		img_path = os.path.join(directory, filename)
		asm_path = os.path.join(directory, f'{os.path.splitext(filename)[0]}.asm')

		with Image.open(img_path) as img:
			if False: # RESIZE
				TAM = 225
				dx = 30
				dy = 30

				# dn = 225/2 - 64

				dx = dy = TAM/2 - 64

				left = dx
				top = dy
				right = TAM - dx
				bottom = TAM - dy
				img = img.crop((left, top, right, bottom))

			img = img.resize((64, 64))
			# img = img.resize((64, 64), resample=PIL.Image.LANCZOS)
			# img = img.resize((64, 64), resample=PIL.Image.BILINEAR)
			# img = img.resize((64, 64), resample=PIL.Image.BICUBIC)
			# img = img.resize((64, 64), resample=PIL.Image.NEAREST)
			
			img = img.transpose(Image.ROTATE_90)
			img = img.transpose(Image.FLIP_LEFT_RIGHT)

			pixels = []

			for x in range(img.width):
				for y in range(img.height):
					pixel = img.getpixel((x, y))
					pixels.append(f'0x00{pixel[0]:02X}{pixel[1]:02X}{pixel[2]:02X}')

			with open(asm_path, 'w') as f:
				f.write(".word " + ",".join(pixels[::-1]))