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
                    keys.add(match.group(1))
    except UnicodeDecodeError as e:
        print(f"Error decoding file '{file_path}': {str(e)}")
    return keys

def get_language_from_path(file_path):
    match = re.search(r'\/([a-zA-Z\-_]+)\.lproj\/', file_path)
    return match.group(1) if match else None

language_keys = defaultdict(set)

def find_strings_files(path):
    for root, _, files in os.walk(path):
        for filename in files:
            if filename.endswith('.strings'):
                file_path = os.path.join(root, filename)
                language = get_language_from_path(file_path)
                if language:
                    language_keys[language].update(extract_keys(file_path))

current_directory = os.getcwd()
find_strings_files(current_directory)

all_keys = set.union(*language_keys.values())
errors = False

for language, keys in language_keys.items():
    missing_keys = all_keys - keys
    extra_keys = keys - all_keys

    if missing_keys:
        print(f"Missing keys in '{language}' localization:")
        for key in missing_keys:
            print(f"  - {key}")
            errors = True

    if extra_keys:
        print(f"Extra keys in '{language}' localization:")
        for key in extra_keys:
            print(f"  - {key}")
            errors = True

exit(errors)
