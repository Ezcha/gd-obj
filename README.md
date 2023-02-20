# gd-obj
`.obj` parser for Godot 4.0
(For a version that works in Godot 3.x check out the [3.x branch](https://github.com/Ezcha/gd-obj/tree/3.x).

## Why?
Godot is unable to import `.obj` files during application runtime. gd-obj enables this functionality by implementing a basic obj parser. gd-obj supports uvs, faces, normals, and does surface triangulation.

## How to use?

### Load from paths
Call `ObjParse.load_obj(path_to_obj, path_to_mtl)`. This will return a `Mesh` which can, for example, be placed into the `mesh` field of a `MeshInstance`.

It will try to find a mtl path if nothing entered. But you can call the function manually `ObjParse.search_mtl_path(path_to_obj)`.

You can also retrieve textures path from `ObjParse.get_mtl_tex_paths(path_to_mtl)` or textures path and data from `ObjParse.get_mtl_tex(path_to_mtl)`.

### Load from buffers
Call `ObjParse.load_mtl_from_buffer(mtl_data,textures)` to get the materials then call `ObjParse.load_obj_from_buffer(obj_data,materials)` to get the `mesh`.
