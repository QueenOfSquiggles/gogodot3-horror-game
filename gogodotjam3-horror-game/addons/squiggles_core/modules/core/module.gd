extends Resource
class_name ModuleDef


var importer_level_parts : EditorImportPlugin

func enable(plugin : EditorPlugin) -> void:
	# Importers
	importer_level_parts = preload("res://addons/squiggles_core/modules/core/import/level_part_importer.gd").new()
	plugin.add_import_plugin(importer_level_parts)

func disable(plugin : EditorPlugin) -> void:
	# Importers
	plugin.remove_import_plugin(importer_level_parts)
