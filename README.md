<div id="badges">
   <img src="https://img.shields.io/badge/Godot_Versions-3.4.x,_3.5.x,_3.6.x-blue" alt="Godot Version"/>
   <img src="https://img.shields.io/badge/Platforms-Linux x86__64-red" alt="Godot Version"/>
</div>

# Godot-Webcam-Integration
This is a Webcam Addon for Godot 3.4 and higher (currently only `Linux x86_64` and `mjpeg` only, via `v4l2`)

# Building Process
## 1) Cloning of git Repository
Clone the git repository and initialize the subrepositories
```sh
git clone --recursive https://github.com/d-sacre/godot-webcam-integration
```
## 2) Building of Library
```
cd ./godot-webcam-integration
mkdir build
cd build
cmake ..
make
```
# Usage
Copy ```webcam-sample-project/webcam``` into your project to use it.
