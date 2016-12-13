extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)

func _fixed_process(delta):
	set_size(get_viewport().get_rect().size)
	get_node("axe").rotate_z(delta)
	
	if Input.is_action_pressed("ui_accept"):
		get_tree().change_scene("res://character_select.tscn")
