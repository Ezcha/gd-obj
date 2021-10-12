extends Node
class_name ObjParse

# Obj parser made by Ezcha
# Created on 7/11/2018
# https://ezcha.net
# https://github.com/Ezcha/gd-obj
# MIT License
# https://github.com/Ezcha/gd-obj/blob/master/LICENSE

# Returns an array of materials from a MTL file

static func _create_mtl(obj:String,textures:Dictionary)->Dictionary:
	var mats := {}
	var currentMat:SpatialMaterial = null

	var lines = obj.split("\n", false)
	for line in lines:
		var parts = line.split(" ", false)
		match parts[0]:
			"#":
				# Comment
				#print("Comment: "+line)
				pass
			"newmtl":
				# Create a new material
				print("Adding new material " + parts[1])
				currentMat = SpatialMaterial.new()
				mats[parts[1]] = currentMat
			"Ka":
				# Ambient color
				#currentMat.albedo_color = Color(float(parts[1]), float(parts[2]), float(parts[3]))
				pass
			"Kd":
				# Diffuse color
				currentMat.albedo_color = Color(float(parts[1]), float(parts[2]), float(parts[3]))
				print("Setting material color " + str(currentMat.albedo_color))
				pass
			_:
				if parts[0] in ["map_Kd","map_Ks","map_Ka"]:
					if textures.has(parts[1]):
						currentMat.albedo_texture = _create_texture(textures[parts[1]])
	return mats

static func _parse_mtl_file(path):
	return _create_mtl(get_data(path),get_mtl_tex(path))

static func _get_image(mtl_filepath:String, tex_filename:String)->Image:
	print("    Debug: Mapping texture file " + tex_filename)
	var texfilepath := mtl_filepath.get_base_dir().plus_file(tex_filename)
	var filetype := texfilepath.get_extension()
	print("    Debug: texture file path: " + texfilepath + " of type " + filetype)
	
	var img:Image = Image.new()
	img.load(texfilepath)
	return img

static func _create_texture(data:PoolByteArray):
	var img:Image = Image.new()
	var tex:ImageTexture = ImageTexture.new()
	img.load_png_from_buffer(data)
	tex.create_from_image(img)
	return tex

static func _get_texture(mtl_filepath, tex_filename):
	var tex = ImageTexture.new()
	tex.create_from_image(_get_image(mtl_filepath, tex_filename))
	print("    Debug: texture is " + str(tex))
	return tex

static func create_obj_from_data(obj_data:String,mat_data:String,textures:Dictionary)->Mesh:
	return _create_obj(obj_data,_create_mtl(mat_data,textures))

static func _create_obj(obj:String,mats:Dictionary)->Mesh:
	# Setup
	var mesh = Mesh.new()
	var vertices = PoolVector3Array()
	var normals = PoolVector3Array()
	var uvs = PoolVector2Array()
	var faces = {}
	var fans = []

	var firstSurface = true
	var mat_name = null

	# Parse
	var lines = obj.split("\n", false)
	for line in lines:
		var parts = line.split(" ", false)
		match parts[0]:
			"#":
				# Comment
				#print("Comment: "+line)
				pass
			"v":
				# Vertice
				var n_v = Vector3(float(parts[1]), float(parts[2]), float(parts[3]))
				vertices.append(n_v)
			"vn":
				# Normal
				var n_vn = Vector3(float(parts[1]), float(parts[2]), float(parts[3]))
				normals.append(n_vn)
			"vt":
				# UV
				var n_uv = Vector2(float(parts[1]), 1 - float(parts[2]))
				uvs.append(n_uv)
			"usemtl":
				# Material group
				mat_name = parts[1]
				if(not faces.has(mat_name)):
					faces[mat_name] = []
			"f":
				# Face
				if (parts.size() == 4):
					# Tri
					var face = {"v":[], "vt":[], "vn":[]}
					for map in parts:
						var vertices_index = map.split("/")
						if (str(vertices_index[0]) != "f"):
							face["v"].append(int(vertices_index[0])-1)
							face["vt"].append(int(vertices_index[1])-1)
							face["vn"].append(int(vertices_index[2])-1)
					faces[mat_name].append(face)
				elif (parts.size() > 4):
					# Triangulate
					var points = []
					for map in parts:
						var vertices_index = map.split("/")
						if (str(vertices_index[0]) != "f"):
							var point = []
							point.append(int(vertices_index[0])-1)
							point.append(int(vertices_index[1])-1)
							point.append(int(vertices_index[2])-1)
							points.append(point)
					for i in (points.size()):
						if (i != 0):
							var face = {"v":[], "vt":[], "vn":[]}
							var point0 = points[0]
							var point1 = points[i]
							var point2 = points[i-1]
							face["v"].append(point0[0])
							face["v"].append(point2[0])
							face["v"].append(point1[0])
							face["vt"].append(point0[1])
							face["vt"].append(point2[1])
							face["vt"].append(point1[1])
							face["vn"].append(point0[2])
							face["vn"].append(point2[2])
							face["vn"].append(point1[2])
							faces[mat_name].append(face)

	# Make tri
	for matgroup in faces.keys():
		print("Creating surface for matgroup " + matgroup + " with " + str(faces[matgroup].size()) + " faces")

		# Mesh Assembler
		var st = SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		if mats.has(matgroup):
			st.set_material(mats[matgroup])
		for face in faces[matgroup]:
			if (face["v"].size() == 3):
				# Vertices
				var fan_v = PoolVector3Array()
				fan_v.append(vertices[face["v"][0]])
				fan_v.append(vertices[face["v"][2]])
				fan_v.append(vertices[face["v"][1]])

				# Normals
				var fan_vn = PoolVector3Array()
				fan_vn.append(normals[face["vn"][0]])
				fan_vn.append(normals[face["vn"][2]])
				fan_vn.append(normals[face["vn"][1]])

				# Textures
				var fan_vt = PoolVector2Array()
				fan_vt.append(uvs[face["vt"][0]])
				fan_vt.append(uvs[face["vt"][2]])
				fan_vt.append(uvs[face["vt"][1]])

				st.add_triangle_fan(fan_v, fan_vt, PoolColorArray(), PoolVector2Array(), fan_vn, [])
		mesh = st.commit(mesh)

	# Finish
	return mesh

static func get_data(path:String)->String:
	var file := File.new()
	file.open(path, File.READ)
	var res:=file.get_as_text()
	return res

static func get_mtl_tex(mtl_path:String)->Dictionary:
	var file := File.new()
	file.open(mtl_path, File.READ)
	var lines := file.get_as_text().split("\n", false)
	file.close()
	var textures := {}
	
	for line in lines:
		var parts = line.split(" ", false)
		if parts[0] in ["map_Kd","map_Ks","map_Ka"]:
			textures[parts[1]] = _get_image(mtl_path, parts[1]).save_png_to_buffer()
	return textures

static func parse_obj(obj_path:String, mtl_path:String="")->Mesh:
	if mtl_path=="":
		mtl_path=obj_path.get_base_dir().plus_file(obj_path.get_file().rsplit(".",false,1)[1]+".mtl")
		var file:File=File.new()
		if !file.file_exists(mtl_path):
			mtl_path=obj_path.get_base_dir().plus_file(obj_path.get_file()+".mtl")
	var obj := get_data(obj_path)
	var mats := _create_mtl(get_data(mtl_path),get_mtl_tex(mtl_path))
	return _create_obj(obj,mats) if obj and mats else null
