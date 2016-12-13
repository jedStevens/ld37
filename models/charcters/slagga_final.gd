extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func set_hide_hammer(b):
	get_node("slagga_arm/Skeleton/hammer").set_hidden(b)