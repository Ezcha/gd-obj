# gd-obj
`.obj` parser for Godot

## Why?
As of Godot 3.2, Godot is unable to import `.obj` files outside of the `res://` directory, or during application runtime.
gd-obj allows either or both of these features. gd-obj supports uvs, faces, normals, and non triangulated meshes.

## How to use?
Call `ObjParse.parse_file(path_to_obj, path_to_mtl)`. This will return a `Mesh` which can, for example, be placed into the `mesh` field of a `MeshInstance`.
