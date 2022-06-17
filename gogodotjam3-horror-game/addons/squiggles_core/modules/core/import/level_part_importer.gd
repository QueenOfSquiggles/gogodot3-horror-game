tool
extends EditorImportPlugin

enum Presets {
	DEFAULT
}

func get_importer_name() -> String:
	return "squiggles.core.level_part_importer"

func get_visible_name() -> String:
	return "Level Part(s)"

func get_recognized_extensions() -> Array:
	return ["scn"] # handle the sub-imported scenes from the main GLTF file

func get_save_extension() -> String:
	return "scn" # theoretically saves as the same?

func get_resource_type() -> String:
	return "PackedScene" # I think this is correct????

func get_preset_count() -> int:
	return Presets.size()

func get_preset_name(preset: int) -> String:
	match preset:
		Presets.DEFAULT:
			return "Default"
		_:
			return "Unknown -> ERROR"

func get_import_options(preset: int) -> Array:
	match preset:
		Presets.DEFAULT:
			return [
				{
					"name" : "generate_physical",
					"default_value" : false
				}
			]
		_:
			return []

func get_option_visibility(option: String, options: Dictionary) -> bool:
	return true

func import(source_file: String, save_path: String, options: Dictionary, platform_variants: Array, gen_files: Array) -> int:
	var scene_file := load(source_file) as PackedScene
	
	if source_file.ends_with("_part.scn") or not options["generate_physical"]:
		# literally change nothing. It's already imported
		return ResourceSaver.save("%s.%s" % [save_path, get_save_extension()], scene_file)
	if not scene_file:
		push_warning("Failed to read imported file as PackedScene : %s" % source_file)
		return 0 # Only limp-wristed dweebs use error codes!
		# I use randomly placed print statements until it works! HA!
	var physics_scene := _create_scene_data(scene_file)
	if not physics_scene:
		push_warning("Failed to generate a physical version of imported file : %s" % source_file)
		return 0
	var packed := PackedScene.new()
	packed.pack(physics_scene)
	var saved_file_path := "%s_part.%s" % [source_file, get_save_extension()]
	gen_files.push_back(saved_file_path)
	var err_code := ResourceSaver.save(saved_file_path, packed)
	if err_code != OK:
		push_error("Import of level part resulted in error code: %s" % str(err_code))
	else:
		print("Successfully imported level part file : %s" % saved_file_path)
	# create dummy imported file so it doesn't reimport every few seconds!
	return ResourceSaver.save("%s.%s" % [save_path, get_save_extension()], scene_file)

func _create_scene_data(scene : PackedScene) -> Spatial:
	var level := scene.instance() as MeshInstance
	if level:
		var root := StaticBody.new()
		root.add_child(level)
		var collider := CollisionShape.new()
		var shape := ConcavePolygonShape.new()
		shape.set_faces(level.mesh.get_faces())
		collider.shape = shape
		root.add_child(collider)
		collider.transform = level.transform # should make collider match up with imported level mesh
		collider.owner = root
		level.owner = root
		root.name = level.name
		level.name = "Mesh(Imported)"
		return root
		# this should produce a scene where the root is a StaticBody and the two children are the imported mesh, and a trimesh collider of the level
		# effectively all this does is automate my process of rebuilding all of the individual mesh colliders for levels
	return null



