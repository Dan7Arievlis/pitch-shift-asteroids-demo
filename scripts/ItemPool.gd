class_name ItemPool
extends Node

@export var ITEM : PackedScene

@export var MAX_ITEMS : int = 100

@onready var items : Dictionary = (func(): 
	var list = {}
	for i in MAX_ITEMS:
		var item = ITEM.instantiate()
		item.visible = false
		item.process_mode = Node.PROCESS_MODE_DISABLED
		item.connect("availability_changed", _on_availability_changed)
		get_tree().current_scene.add_child.call_deferred(item)
		list[item] = true
	return list).call()


func get_first_item() -> Node2D:
	for item in items.keys():
		if items[item]:
			items[item] = false
			return item
	return null


func _on_availability_changed(node : Node2D, available : bool) -> void:
	items[node] = available
