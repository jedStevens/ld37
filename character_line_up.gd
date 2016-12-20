extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	for character in get_node("characters").get_children():
		var rot = Vector3(0,atan2(character.get_translation().x, character.get_translation().z) + PI, 0)
		character.set_rotation(rot)