extends BehaviorTree

class_name BehaviorTreeRoot, "../icons/tree.svg"

const Blackboard = preload("../blackboard.gd")

export (NodePath) var actor_path : NodePath
export (bool) var enabled := true

onready var actor := get_node(actor_path) as Node
onready var blackboard := Blackboard.new()

func _ready() -> void:
	assert(self.get_child_count() == 1,"Behavior Tree error: Root should have one child")

func tick_tree(delta : float) -> void:
	if not enabled:
		return
	blackboard.set("delta", delta)
	self.get_child(0).tick(actor, blackboard)


func enable() -> void:
	self.enabled = true

func disable() -> void:
	self.enabled = false
