#!/usr/bin/env python3

import os
import sys
import shutil

def copy_localization_files(source_dir, target_dir):
    for root, _, files in os.walk(source_dir):
        for file in files:
            if file.endswith(('.strings', '.stringsdict')):
                source_file_path = os.path.join(root, file)
                rel_path = os.path.relpath(source_file_path, source_dir)
                target_file_path = os.path.join(target_dir, rel_path)
                shutil.copy2(source_file_path, target_file_path)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: ./export.sh <target_root_dir>")
        sys.exit(1)

    target_root_dir = sys.argv[1]

    if not os.path.exists(target_root_dir):
        print(f"Target root directory '{target_root_dir}' does not exist.")
        sys.exit(1)

    source_root_dir = os.getcwd()  

    for source_subdir, _, _ in os.walk(source_root_dir):
        target_subdir = os.path.join(target_root_dir, os.path.basename(source_subdir))

        if os.path.exists(target_subdir):
            copy_localization_files(source_subdir, target_subdir)
            print(f"Localization files copied from '{source_subdir}' to '{target_subdir}'.")

    print("Localization files copied successfully.")
