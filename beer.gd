extends RigidBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var empty = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_beer_body_enter( body ):
	if empty: return
	if body.is_in_group("player"):
		empty = true
		body.drink(self)
		queue_free()