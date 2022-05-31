extends ActionLeaf

export (NodePath) var camera_path : NodePath
export (NodePath) var camera_pivot_path : NodePath

export (NodePath) var selection_cast : NodePath
export (NodePath) var held_object_root : NodePath

export (NodePath) var animation_player : NodePath


#export (NodePath) var _ : NodePath

func tick(_actor : Node, bb : Blackboard) -> int:

	bb.set("camera", get_node(camera_path))
	bb.set("cam_pivot", get_node(camera_pivot_path))
	
	bb.set("selection_cast", get_node(selection_cast))
	bb.set("held_object_root", get_node(held_object_root))
	
	bb.set("animation_player", get_node(animation_player))
	
	return SUCCESS
