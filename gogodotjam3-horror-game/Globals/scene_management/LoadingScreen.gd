extends Control
class_name LoadingScreen


export (NodePath) var path_title : NodePath
export (NodePath) var path_progress_bar : NodePath

onready var title : Label = get_node(path_title) as Label
onready var progress_bar : ProgressBar = get_node(path_progress_bar) as ProgressBar


func update_progress(name : String, value : float) -> void:
	title.text = name
	progress_bar.value = value * 100.0 # number is raw percentage

