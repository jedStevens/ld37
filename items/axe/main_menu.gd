extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


#Starting phrases 5-7?
var phrases = [
"Drink, Drink, Drink!!!",
"Axe your friend out for a drink tonight",
"Get your mug and your horned helmet, its about to get barbaric!",
"Drink and destroy!"
]

var mead_timer = 1.5

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	randomize()
	
	var i = randi() % phrases.size()
	
	get_node("CenterContainer/VBoxContainer/phrase").set_text(phrases[i])

func _fixed_process(delta):
	set_size(get_viewport().get_rect().size)
	
	if Input.is_action_pressed("ui_accept"):
		get_tree().change_scene("res://character_select.tscn")

func _on_resetter_body_enter( body ):
	
	var i = randi() % get_node("spawns").get_children().size()
	
	body.set_translation(get_node("spawns").get_child(i).get_translation())
	body.set_linear_velocity(Vector3(0,0,0))
