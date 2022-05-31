extends Node
"""
Persistence Manager : an autoload script that handles persistence for almost any scene
it does need to be configured to handle specific games but is a really good base for starting out
It does have to be called manually from the scene that needs persistence, so it isn't fully automatic.

"""
# the group name for objects recognized as persistent objects
const PERSISTENT_OBJ_GROUP_NAME := "persist"

# a constant prefix for all saves
const SAVE_PATH_PREFIX := "user://saves/"
const SAVE_FILE_TYPE := ".save"

# A custom suffix for setting up a multiple saves system
var custom_save_suffix := "save_slot/"

const Y_DELETION_CUTOFF := -150.0

# limits the number of objects removed per frame
# this makes sure we don't have a massive stutter at the start of the level
# this could be a const, but I like the idea that specific scenes can set their own rate based on needs unique to that scene
var destructions_per_frame := 50

var scene_cache := {}

func get_save_data_for(node : Node) -> Dictionary:
	"""
	The general purpose save data manager
	"""
	if node.filename.empty():
		# node is not instanced. no save data
		print("node [%s] skipped; no scene filename found" % str(node.name))
		return {}

	var data := {
		# load basic save data
		"node_path" : get_tree().current_scene.get_path_to(node),
		"parent_path" : get_tree().current_scene.get_path_to(node.get_parent()),
		"scene_file" : node.filename,
		"node_name" : node.name,
	}
	if node is Spatial:
		# save data for all spatials
		var spat := node as Spatial
		data["translation"] = spat.translation
		data["rotation"] = spat.rotation_degrees # use degress because parsing is lossy with floats and degrees will yield a higher accuracy
		if spat.global_transform.origin.y < Y_DELETION_CUTOFF:
			# don't save the object, treat as deleted
			return {}
	if node is RigidBody:
		data["rigid_body_mode"] = (node as RigidBody).mode
	if node.has_method("save_data"):
		var node_data := node.save_data() as Dictionary
		if node_data and not node_data.empty():
			data["custom_data"] = node_data
	return data

func load_obj_from_data(data : Dictionary) -> void:
	"""
	This method loads in the data and possibly nodes from the data depending on desired functionality
	"""
	var node := get_tree().current_scene.get_node_or_null(data["node_path"])
	if node and destruction_queue.has(node):
		# exists in scene already, simply do not delete
		destruction_queue.erase(node)
	else:
		var scene_file :String = data["scene_file"]
		var packed : PackedScene
		if scene_cache.has(scene_file):
			packed = scene_cache[scene_file]
		else:
			packed = load(scene_file)
			if not packed:
				push_error("Failed to load scene data from path [%s]. Instanced object not loaded" % str(scene_file))
				return
			scene_cache[scene_file] = packed
		node = packed.instance()
		var dest_path : NodePath = data["parent_path"]
		get_tree().current_scene.get_node(dest_path).add_child(node)
		node.name = data["node_name"]
	if node is Spatial:
		apply_spatial_data(node, data)
	if node is RigidBody:
		(node as RigidBody).mode = int(data["rigid_body_mode"])
	if node.has_method("load_save_data"):
		node.load_save_data(data["custom_data"])

func apply_spatial_data(node : Spatial, data : Dictionary)-> void:
	# applys desired spatial data
	node.translation = parse_vector3(data["translation"])
	node.rotation_degrees = parse_vector3(data["rotation"])

func parse_vector3(vec : String) -> Vector3:
	vec = vec.substr(1, vec.length()-2)
	var floats := vec.split_floats(",", false)
	if floats.size() != 3:
		push_error("input string [%s] was not valid to be parsed as a Vector3" % str(vec))
	var result := Vector3(floats[0], floats[1], floats[2])
	#print("Parsed [%s] -> [%s]" % [str(vec), str(result)])
	return result

"""
	Edit above to customize functionality
	- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



	This space intentionally left blank to make the seperation super obvious
"""
#
#	< 0  \|/
#		  3
#	< 0  /|\
#
"""
	- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Leave below alone if no advanced changes are needed
"""
signal on_saving
signal on_loading

# a local queue for destruction. This is loaded
var destruction_queue := []

func does_save_data_exist() -> bool:
	var file := open_file(get_current_save_name(), File.READ)
	if not file:
		return false
	var flag := file.file_exists(get_current_save_name())
	file.close()
	return flag

func does_save_data_exist_for(scene_name : String = "") -> bool:
	var path :=get_save_name_for(scene_name)
	var file := open_file(path, File.READ)
	if not file:
		return false
	var flag := file.file_exists(path)
	file.close()
	return flag


func load_save_data() -> void:
	var file := open_file(get_current_save_name(), File.READ)
	if not file:
		# no file, save data doesn't exist yet
		return
	var line := file.get_line()
	destruction_queue = get_persistant_objs()
	while not line.empty():
		load_obj_from_data(parse_json(line))
		line = file.get_line()
	file.close()
	if not destruction_queue.empty():
		print("%s objects queued for deletion" % str(destruction_queue.size()))
		set_process(true)
	emit_signal("on_loading")
	scene_cache.clear()

func save_data() -> void:
	var dir := Directory.new()
	var _err = dir.remove(get_current_save_name()) # delete old file, we want clean data

	# open file for writing (will create a new file)
	var file := open_file(get_current_save_name(),File.WRITE)
	if not file:
		print("FAILED TO OPEN FILE???")
		return

	var scene_objects := get_persistant_objs()
	#print("Saving data for ", scene_objects.size(), " persistent objects")
	for i in range(scene_objects.size()):
		var obj := scene_objects[i] as Node
		var data := get_save_data_for(obj)
		if not data.empty():
			file.store_line(to_json(data))
	file.close()
	emit_signal("on_saving")

func get_persistant_objs() -> Array:
	"""
	just a helper method for getting the nodes in the persistent group
	"""
	var objs := get_tree().get_nodes_in_group(PERSISTENT_OBJ_GROUP_NAME)
	if objs.empty():
		push_warning("no persistent objects found in current scene tree")
	return objs

func _process(_delta: float) -> void:
	"""
	slowly clear out entries in the destruction queue
	"""
	if destruction_queue.empty():
		# once that's empty, nothing more to do
		set_process(false)
		return
	var num := min(destructions_per_frame, destruction_queue.size())
	for i in range(num):
		var entry :Node = destruction_queue[i]
		if not is_instance_valid(entry):
			push_warning("destruction queue item was not a valid instance [%s]" % str(entry))
			continue
		print("Deleting entry [%s] [%s / %s]" % [str(entry), str(i), str(num)])
		entry.queue_free()
	for _i in range(num):
		destruction_queue.remove(0)

func open_file(path: String, open_flags) -> File:
	"""
	Opens the current save file
	"""
	ensure_filepath(get_current_save_dir())
	var file := File.new()
	var err := file.open(path, open_flags)
	if err != OK:
		print("failed to open file : ", path)
		return null
	#print("Opened file [", path, "]")
	return file

func ensure_filepath(path : String) -> void:
	"""
	Make sure the filepath exists so writing out to the file works
	"""
	var dir := Directory.new()
	if dir.file_exists(path):
		return
	var err := dir.make_dir_recursive(path)
	assert(err == OK, "Something failed with creating the path")

func get_save_name_for(scene_name : String = "", suffix : String = "") -> String:
	return get_current_save_dir() + scene_name + suffix + SAVE_FILE_TYPE

func get_current_save_name(suffix : String = "") -> String:
	"""
	Generates a save file path for the currently loaded scene
	This means that we don't need any special logic to save data for a different scene.
	It's all automagic :3
	"""
	var scene_name := get_tree().current_scene.name
	return get_save_name_for(scene_name, suffix)

func get_current_save_dir() -> String:
	return SAVE_PATH_PREFIX + custom_save_suffix

func save_custom_data(suffix : String, data : Dictionary) -> void:
	var dir := Directory.new()
	var _err = dir.remove(get_current_save_name(suffix))
	var file := open_file(get_current_save_name(suffix),File.WRITE)
	file.store_var(data, false)
	file.close()

func load_custom_data(suffix : String) -> Dictionary:
	var file := open_file(get_current_save_name(suffix),File.READ)
	if not file:
		return {}

	var v = file.get_var(false)
	var data := v as Dictionary
	file.close()
	return data

func delete_data() -> void:
	delete_dir(get_current_save_dir())

func delete_dir(path : String) -> void:
	var dir := Directory.new()
	if not dir.dir_exists(get_current_save_dir()):
		# directory already deleted
		return
	if dir.open(get_current_save_dir()) != OK:
		return
	var _err = dir.list_dir_begin()
	var filename := dir.get_next()
	var queue := []
	while filename:
		if dir.current_is_dir():
			if not (filename == ".." or filename == "."):
				var f_path := path + filename
				delete_dir(f_path)
		else:
			queue.append(filename)
		filename = dir.get_next()
	dir.list_dir_end()

	for file in queue:
		_err = dir.remove(file)
	_err = dir.remove(path)

func save_generic(file_path : String, data : Dictionary) -> int:
	if not data:
		return ERR_INVALID_DATA
	var file := File.new()
	var err := file.open(file_path, File.WRITE)
	if err != OK:
		return err
	var text := JSON.print(data, "\t", true)
	file.store_string(text)
	file.close()
	return OK

func load_generic(file_path : String) -> Dictionary:
	var file := File.new()
	var err := file.open(file_path, File.READ)
	if err != OK:
		return {}
	var text : String = file.get_as_text()
	if not text:
		return {}
		
	return JSON.parse(text).result as Dictionary

func delete_generic(file_path : String) -> int:
	var file := File.new()
	if file.file_exists(file_path):
		var dir := Directory.new()
		var err = dir.open(file_path.get_base_dir())
		if err != OK:
			return err
		return dir.remove(file_path.get_file())
	return OK
