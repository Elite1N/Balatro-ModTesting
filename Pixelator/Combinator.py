import os
from PIL import Image

def combine_images(input_folder, output_path, images_per_row=10, bg_color=(0, 0, 0, 0)):
    # Collect image file paths
    image_files = [f for f in os.listdir(input_folder) if f.lower().endswith(('.png', '.jpg', '.jpeg', '.bmp', '.gif'))]
    image_files.sort()
    images = []
    for filename in image_files:
        img = Image.open(os.path.join(input_folder, filename)).convert('RGBA')
        images.append(img)

    if os.path.isdir(output_path):
        output_path = os.path.join(output_path, 'Kaiju.png')

    if not images:
        print("No images found in the folder.")
        return

    num_images = len(images)
    rows = (num_images + images_per_row - 1) // images_per_row

    # Calculate width and height for each row
    row_widths = []
    row_heights = []
    for row in range(rows):
        row_imgs = images[row * images_per_row : (row + 1) * images_per_row]
        row_width = sum(img.width for img in row_imgs)
        row_height = max(img.height for img in row_imgs)
        row_widths.append(row_width)
        row_heights.append(row_height)

    total_width = max(row_widths)
    total_height = sum(row_heights)

    combined = Image.new('RGBA', (total_width, total_height), bg_color)

    y = 0
    img_idx = 0
    for row in range(rows):
        x = 0
        for col in range(images_per_row):
            if img_idx >= num_images:
                break
            img = images[img_idx]
            combined.paste(img, (x, y), img)
            x += img.width
            img_idx += 1
        y += row_heights[row]

    output_path = os.path.splitext(output_path)[0] + '.png'
    combined.save(output_path, format='PNG')
    print(f"Combined image saved to {output_path}")

if __name__ == "__main__":
    import sys
    if len(sys.argv) < 3:
        print("Usage: python Combinator.py <input_folder> <output_folder>")
        sys.exit(1)
    input_folder = sys.argv[1]
    output_file = sys.argv[2]
    combine_images(input_folder, output_file)
