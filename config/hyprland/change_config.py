#!/usr/bin/env python3
from io import FileIO
import os
import json
import sys
import shutil

with open("./current_config.json") as f:
    data = json.load(f)

CURRENT_CONFIG = data["current_config"]


def delete_files() -> None:
    print(f"Deleting current config files: {CURRENT_CONFIG}!")
    for file_or_folder in os.listdir():
        if file_or_folder in ["alternatives", "change_config.py", "current_config.json"]:
            continue
        try:

            if os.path.isfile(file_or_folder): 
                os.remove(file_or_folder)
            else:
                shutil.rmtree(file_or_folder)
        except FileNotFoundError:
            sys.stderr.write(f"ERROR: File: {file_or_folder} was not found...")
            exit(1)
        except OSError:
            sys.stderr.write(f"ERROR: File: {file_or_folder} could not be deleted...")
            exit(1)

def copy_files() -> None:
    try:
        shutil.copytree("./alternatives/" + config, "./")
    except:
        sys.stderr.write("ERROR: Something went wrong! Could not copy the new config to the current working directory!")
        exit(1)

def change_config() -> None:
    print("Changing the configs!")
    delete_files()
    print(f"Succefully removed all files from the current config: {CURRENT_CONFIG}!") 
    print(f"Copying the new config ({config}) to the current working directory!")
    copy_files()
    print(f"Succefully copied the new config: {config} to the current working directory!")


def main() -> None:
    print("[WARNING]: Don't change configs in the same WM!")
    if len(sys.argv) == 1:
        config = sys.argv[1]
    else:
        config = input("Input the config you want to change to: ")

    if config in ["-h", "--help", "help", "h"]:
        print("This script helps to change the Hyprland config.\nIt accepts one positional argument that is the name of the folder where the config you wish to chenge to is located.")
        exit(0)

    elif input == CURRENT_CONFIG:
        sys.stderr.write("The config to change to must not be the same as the current config!")
        exit(1)

    if not os.path.isdir("./alternatives/" + config):
        sys.stderr.write(f"ERROR: The config: {config} does not exist!")
        exit(1)

    try:
        change_config()
    except:
        sys.stderr.write("ERROR: Something unexpected went wrong! Could not change the config!")
        exit(1)
    




if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\nBye...")
else:
    print("Please die away from me you animal...")
