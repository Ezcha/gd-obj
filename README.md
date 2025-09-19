# gd-obj (ObjParse)

A simple `.obj` parser for Godot 4.X

(For a version that works in Godot 3.X check out the [3.X branch](https://github.com/Ezcha/gd-obj/tree/3.x).)

## Why?

Godot is unable to import `.obj` files during application runtime. gd-obj enables this functionality by
implementing a basic obj parser. gd-obj supports uvs, faces, normals, and does surface triangulation.

## How to use?

### Setup

Simply include the `obj_parse.gd` file anywhere in your Godot project.

### Load from paths

Call `ObjParse.from_path(obj_path, mtl_path)`. This will return a `Mesh` which can, for example,
be placed into the `mesh` field of a `MeshInstance`.

The second argument `mtl_path` is optional. When excluded the parser will check if a materials file is
specified in the `.obj` data and will automatically load it if valid.

### Load from memory

To load models/materials from memory `ObjParse.from_mtl_string(mtl_data, textures)` can be used to get the
materials dictionary and then `ObjParse.from_obj_string(obj_data, materials)` to get create `Mesh` object.
