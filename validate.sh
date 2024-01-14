#!/usr/bin/env python3

import os
import re
from collections import defaultdict

def extract_keys(file_path):
    keys = set()
    try:
        with open(file_path, 'rb') as file:
            content = file.read().decode('utf-8')
            for line in content.splitlines():
                match = re.match(r'\s*"(.*?)"\s*=\s*".*?";', line)
                if match:
                    key = match.group(1)
                    keys.add(key)
    except UnicodeDecodeError as e:
        print(f"Error decoding file '{file_path}': {str(e)}")
    return keys

first_file_keys = set()

file_paths = []
file_keys = defaultdict(set)

def find_strings_files(path):
    for root, _, files in os.walk(path):
        for filename in files:
            if filename.endswith('.strings'):
                file_path = os.path.join(root, filename)
                file_paths.append(file_path)
                keys = extract_keys(file_path)
                if not first_file_keys:
                    first_file_keys.update(keys)
                file_keys[file_path] = keys

current_directory = os.getcwd()
find_strings_files(current_directory)

for file_path in file_paths:
    if file_path in file_keys:  
        missing_keys = first_file_keys - file_keys[file_path]
        new_keys = file_keys[file_path] - first_file_keys

        if missing_keys:
            print(f"Missing keys in file '{file_path}':")
            for key in missing_keys:
                print(f"  - {key}")

        if new_keys:
            print(f"Unknown keys in file '{file_path}':")
            for key in new_keys:
                print(f"  - {key}")
