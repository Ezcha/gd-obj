# gd-obj
`.obj` parser for Godot

## Why?
As of Godot 3.2, Godot is unable to import `.obj` files outside of the `res://` directory, or during application runtime.
gd-obj allows either or both of these features. gd-obj supports uvs, faces, normals, and non triangulated meshes.

## How to use?
Create a new instance of `ObjParse`.
Call `.parse_file(path_to_file)` or `parse_string(str_content)` from it. It will return a `Mesh` instance.
