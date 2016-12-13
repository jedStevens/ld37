extends "player.gd"

var block_timer = -1
var stab_timer = -1

var block_dur = 1.25
var stab_dur = 0.4

var THRUST_SPEED = 15

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)

func _fixed_process(delta):
	# Attacks
	if block_timer > 0:
		block_timer -= delta
	elif stab_timer > 0:
		stab_timer -= delta
		move(Vector3(0,0,0))
		if is_colliding():
			var col = get_collider()
			if col:
				print("svard hit: ",col.get_name())
				if col.is_in_group("static"):
					stab_timer = -1
				if col.is_in_group("player"):
					col.health -= 1
					col.grant_immunity(1.5)
			
	
	if block_timer < 0 and stab_timer < 0:
		lock = false
	if block_timer < 0 and Input.is_action_just_pressed("player_"+str(id)+"_right_action"):
		#block in aim dir and lock til un press, 1 sec block min
		get_node("viking/AnimationPlayer").play("block")
		lock = true
		block_timer = block_dur
		velocity.x = 0 
		velocity.z = 0
		get_node("viking").set_rotation(Vector3(0, atan2(aim_dir.normalized().x, aim_dir.normalized().z), 0))
	
	elif stab_timer < 0 and Input.is_action_just_pressed("player_"+str(id)+"_left_action"):
		get_node("viking/AnimationPlayer").play("stab")
		lock = true
		stab_timer = stab_dur
		velocity = aim_dir.normalized() * THRUST_SPEED * delta
		get_node("viking").set_rotation(Vector3(0, atan2(aim_dir.normalized().x, aim_dir.normalized().z), 0))