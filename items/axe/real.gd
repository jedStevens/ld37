extends RigidBody

var target = null

var SPEED = 20

var velocity = Vector3(0,0,0)
var can_pick_up = false

var start_angle = 30
var end_angle = 90

var id = 0

var lob_factor = 0.1

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
		
	
func set_target(t, charge):
	target = t
	
	if target != null:
		velocity = (target - get_translation()).normalized() * SPEED 
		
		var launch = velocity
		velocity.y = SPEED * charge
		
		velocity = velocity.normalized() * SPEED
	
	apply_impulse(Vector3(0,0,0), velocity)
	

func _on_axe_body_enter( body ):
	if body.is_in_group("player"):
		if id == body.id and can_pick_up:
			var res = body.give_axe(self)
			if res:
				queue_free()
		elif id != body.id and not can_pick_up:
			print(body.id, " got hit by an axe from ", id)
			body.health -=1
			body.grant_immunity(body.immunity_duration)
	elif body.is_in_group("static") and not can_pick_up:
		can_pick_up = true

func set_particle_material(mat):
	get_node("Particles").set_material_override(mat)