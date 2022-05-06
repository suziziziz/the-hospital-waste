extends Control

export var _c_test = 0
export(PackedScene) var nextScene

func _ready():
	var n = nextScene.instance()
	get_tree().get_root().call_deferred("add_child", n)
	queue_free()
