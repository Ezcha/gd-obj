# gd-obj
`.obj` parser for Godot

## Why?
As of Godot 3.2, Godot is unable to import `.obj` files outside of the `res://` directory, or during application runtime.
gd-obj allows either or both of these features. gd-obj supports uvs, faces, normals, and non triangulated meshes.

## How to use?

### Load from paths
Call `ObjParse.load_obj(path_to_obj, path_to_mtl)`. This will return a `Mesh` which can, for example, be placed into the `mesh` field of a `MeshInstance`.

It will try to find a mtl path if nothing entered. But you can call the function manually `ObjParse.search_mtl_path(path_to_obj)`.

You can also retrieve textures path from `ObjParse.get_mtl_tex_paths(path_to_mtl)` or textures path and data from `ObjParse.get_mtl_tex(path_to_mtl)`.

### Load from buffers
Call `ObjParse.load_mtl_from_buffer(mtl_data,textures)` to get the materials then call `ObjParse.load_obj_from_buffer(obj_data,materials)` to get the `mesh`.
