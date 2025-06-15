import os
from PIL import Image

def pixelate_image(input_path, output_path, size=(71, 95)):
    img = Image.open(input_path).convert('RGBA')
    img_small = img.resize(size, resample=Image.NEAREST)
    # Always save as PNG
    output_path = os.path.splitext(output_path)[0] + '.png'
    img_small.save(output_path, format='PNG')
    print(f"Pixelated image saved to {output_path}")

def pixelate_folder(input_folder, output_folder, output_folder2, size=(71, 95)):
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)
    if not os.path.exists(output_folder2):
        os.makedirs(output_folder2)
    for filename in os.listdir(input_folder):
        if filename.lower().endswith(('.png', '.jpg', '.jpeg', '.bmp', '.gif')):
            input_path = os.path.join(input_folder, filename)
            base_name = os.path.splitext(filename)[0] + '.png'
            output_path = os.path.join(output_folder, base_name)
            output_path2 = os.path.join(output_folder2, base_name)
            pixelate_image(input_path, output_path, size)
            pixelate_image(output_path, output_path2, size=(142, 190))

if __name__ == "__main__":
    import sys
    if len(sys.argv) < 4:
        print("Usage: python Pixelator.py <input_folder> <output_folder> <output_folder2>")
        sys.exit(1)
    input_folder = sys.argv[1]
    output_folder = sys.argv[2]
    output_folder2 = sys.argv[3]
    pixelate_folder(input_folder, output_folder, output_folder2)