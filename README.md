# gd-obj
Obj file parser for Godot

## Why?
You might find yourself asking why this is needed. And that is a very good question. Godot may already allow you to import obj model files into the editor, but there is one major problem. You cannot import external obj files. So if you may want to create DLC, plan on using user created content, or want to download and use an obj file while running, you would not be able to do so. This is where gd-obj comes in. gd-obj parses obj files and returns them as a Mesh instance. It supports uvs, faces, normals, and non triangulated meshes.

## How to use?
Create a node and attach the ObjParse.gd script to it. In another node find the parser node and run .parse(path_to_obj) from it. It will return a Mesh instance.
