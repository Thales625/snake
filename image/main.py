from PIL import Image

with Image.open('image.png') as img:
	img = img.resize((64, 64))
	
	img = img.transpose(Image.ROTATE_90)

	pixels = []

	for x in range(img.width):
		for y in range(img.height):
			pixel = img.getpixel((x, y))
			pixels.append(f'0x00{pixel[0]:02X}{pixel[1]:02X}{pixel[2]:02X}')

	with open('data.asm', 'w') as f:
		f.write(".data\n\tframebuffer: .word " + ",".join(pixels))