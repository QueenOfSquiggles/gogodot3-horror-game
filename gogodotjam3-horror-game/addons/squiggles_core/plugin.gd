tool
extends EditorPlugin

const modules := [
	"core"
]

const module_cache := {
	# empty Dictionary, just caches the module scripts so we can unload them at the end or reference it somewhere
}

func _enter_tree() -> void:
	for module in modules:
		var m := load("res://addons/squiggles_core/modules/%s/module.gd" % module).new() as ModuleDef
		if m:
			m.enable(self)
			module_cache[module] = m


func _exit_tree() -> void:
	for module in module_cache.keys():
		var m := module_cache[module] as ModuleDef
		m.disable(self)
