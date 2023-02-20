# gd-obj

`.obj` parser for Godot 4.0

(For a version that works in Godot 3.x check out the [3.x branch](https://github.com/Ezcha/gd-obj/tree/3.x).)

## Why?

Godot is unable to import `.obj` files during application runtime. gd-obj enables this functionality by implementing a basic obj parser. gd-obj supports uvs, faces, normals, and does surface triangulation.

## How to use?

### Setup

Simply include the `ObjParse.gd` file anywhere in your Godot project.

### Load from paths

Call `ObjParse.load_obj(path_to_obj, path_to_mtl)`. This will return a `Mesh` which can, for example, be placed into the `mesh` field of a `MeshInstance`.

The second argument `path_to_mtl` is optional. When excluded the parser will check if a materials file is specified in the `.obj` data and will automatically load it if valid.

### Load from buffers

Call `ObjParse.load_mtl_from_buffer(mtl_data, textures)` to get the materials then call `ObjParse.load_obj_from_buffer(obj_data, materials)` to get the `mesh`.
