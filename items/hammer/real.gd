extends RigidBody

var target = null

var SPEED = 25

var velocity = Vector3(0,0,0)
var can_pick_up = false

var id = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)

func set_player_id(_id):
	id = _id

func _fixed_process(delta):
	for body in get_colliding_bodies():
		if body.is_in_group("static"):
			set_linear_velocity(Vector3(0,0,0))
			can_pick_up = true
		if body.is_in_group("player") and can_pick_up and body.id == id:
			var res = body.give_axe(self)
			if res:
				queue_free()
		
	
func set_dir(v):
	velocity = v.normalized() * SPEED
	apply_impulse(Vector3(0,0,0), velocity)


func set_particle_material(mat):
	get_node("Particles").set_material_override(mat)

func _on_hammer_body_enter( body ):
	if body.is_in_group("player"):
		if id == body.id and can_pick_up:
			var res = body.give_hammer(self)
			if res:
				queue_free()
		elif id != body.id and not can_pick_up:
			print(body.id, " got hit by a hammer from ", id)
			body.health -=1
			body.grant_immunity(body.immunity_duration)
	elif body.is_in_group("static") and not can_pick_up:
		can_pick_up = true
