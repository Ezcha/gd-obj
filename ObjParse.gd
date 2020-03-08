extends Node

# Obj parser made by Ezcha
# Created on 7/11/2018
# https://ezcha.net
# https://github.com/Ezcha/gd-obj
# MIT License
# https://github.com/Ezcha/gd-obj/blob/master/LICENSE

var mat

func _ready():
	mat = SpatialMaterial.new()
	mat.albedo_color = Color(1, 1, 1)
	mat.flags_transparent = false
	mat.depth_enabled = false

func parse_file(path):
	var file = File.new()
	file.open(path, File.READ)
	var obj = file.get_as_text()
	return parse_str(obj)
	
func parse_str(body):	
	# Setup
	var mesh = Mesh.new()
	var vertices = PoolVector3Array()
	var normals = PoolVector3Array()
	var uvs = PoolVector2Array()
	var faces = []
	var fans = []
	
	# Parse
	var lines = body.split("\n", false)
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
				var n_uv = Vector2(float(parts[1]), float(parts[2]))
				uvs.append(n_uv)
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
					faces.append(face)
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
							faces.append(face)
	
	# Assemble
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	# Make tri
	for face in faces:
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
		
	st.set_material(mat)
	st.commit(mesh)
	
	# Finish
	return mesh
