#!/usr/bin/env python3

import os
import sys
import shutil

def copy_localization_folders(source_dir):
    for root, dirs, files in os.walk(source_dir):
        for directory in dirs:
            if directory.endswith('.lproj'):
                localization_dir = os.path.join(root, directory)
                for _, _, localization_files in os.walk(localization_dir):
                    for file in localization_files:
                        if file.endswith(('.strings', '.stringsdict')):
                            source_file_path = os.path.join(localization_dir, file)
                            target_file_path = os.path.join(os.getcwd(), directory, file)
                            os.makedirs(os.path.dirname(target_file_path), exist_ok=True)
                            shutil.copy2(source_file_path, target_file_path)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: ./import.sh <source_dir>")
        sys.exit(1)

    source_dir = sys.argv[1]

    if not os.path.exists(source_dir):
        print(f"Source directory '{source_dir}' does not exist.")
        sys.exit(1)

    copy_localization_folders(source_dir)
    print(f"Localization folders copied from '{source_dir}' to current directory.")
