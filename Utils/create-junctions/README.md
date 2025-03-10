# create-junctions.bat
Can be used to automatically create junctions to 
- Energy Shaders \[Java]/current/Energy Shaders \[Java]
- NightVisionShaders \[Java]/current/Night Vision Shaders \[Java]

## Requirements:
- Directory containing [junction64.exe](https://learn.microsoft.com/en-us/sysinternals/downloads/junction)
  must be in `PATH` environment variable
- Environment variable `MC_SHADERS_DEV_ROOT` must be set to the root of this repo.

## How to run:
Copy the `create-junctions.bat` file where you want to create the junctions and run it there **as Administrator** 