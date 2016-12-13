extends "player.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var has_hammer = true
var charging_throw = false
var swinging = false

var blink_distance = 8

var blink_timer = -1
var blink_cooldown = 3
var default_lob = 0.5


#Throw hammer, and call back on right hand
#Left teleports forward a short distance

func equip_hammer():
	get_node("viking").set_hide_hammer(false)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)

func _fixed_process(delta):
	#Attacks
	if blink_timer > 0:
		blink_timer -= delta
		
	if Input.is_action_just_pressed("player_"+str(id)+"_left_action") and blink_timer < 0:
		move_to(get_translation() + aim_dir.normalized() * blink_distance + Vector3(0,0.25,0))
		get_node("viking").set_rotation(Vector3(0, atan2(aim_dir.x, aim_dir.z), 0))
		blink_timer = blink_cooldown
		get_node("SamplePlayer2D").play("blink")
		
	if Input.is_action_just_pressed("player_"+str(id)+"_right_action") and has_hammer and get_node("RayCast").is_colliding():
		get_node("viking/AnimationPlayer").play("hammer_throw")
		get_node("viking").set_hide_hammer(true)
		get_node("viking").set_rotation(Vector3(0, atan2(aim_dir.x, aim_dir.z), 0))
		get_node("SamplePlayer2D").play("throw")
		
		var hammer = preload("res://items/hammer/real.tscn").instance()
		var lob_dir = aim_dir
		lob_dir.y = default_lob
		hammer.set_translation(get_translation() + lob_dir)
		hammer.set_rotation(get_node("viking").get_rotation() + Vector3(0,PI,0))
		hammer.set_dir(aim_dir)
		hammer.set_player_id(id)
		hammer.set_particle_material(guide_material)
		get_node("../../items").add_child(hammer)
		
		has_hammer = false

func give_hammer(h):
	if not h.can_pick_up:
		false
	if has_hammer:
		return false

	if not has_hammer:
		equip_hammer()
		has_hammer = true
		h.can_pick_up = false
		return true