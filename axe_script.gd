extends "player.gd"

var target = Vector3(0,0,0)

var charging_left = false
var charging_right = false

var has_left_axe = true
var has_right_axe = true

var target_L = Vector3(0,0,0)
var target_R = Vector3(0,0,0)

var max_charge_dur = 0.2

var charge_l = 0
var charge_r = 0

var THROW_DISTANCE = 2


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)

func equip_axe(hand):
	var axe_node = preload("res://items/axe/equiped.tscn").instance()
	axe_node.get_node("Particles").set_material_override(guide_material)
	get_node("viking/Armature/Skeleton/hand_"+hand).add_child(axe_node)

func _fixed_process(delta):
	var sum = Vector3(0,0,0)
	var t = 0
	if charging_left:
		sum += target_L
		t += 1
	if charging_right:
		sum += target_R
		t += 1

	if t > 0:
		sum =  sum / t
		get_node("viking").set_rotation(Vector3(0, atan2(sum.x - get_translation().x, sum.z - get_translation().z), 0))


	# Attacks
	#Start the attack, charging energy or whatever
	if Input.is_action_just_pressed("player_"+str(id)+"_left_action"):
		charging_left = true
		charge_l = 0
	if charging_left:
		target_L = get_translation() + aim_dir * THROW_DISTANCE
		charge_l += delta
		#Unequip the left axe and create a "throwing axe" object
	if Input.is_action_just_pressed("player_"+str(id)+"_right_action"):
		charging_right = true
		charge_r = 0
	if charging_right:
		target_R = get_translation() + aim_dir * THROW_DISTANCE
		charge_r += delta

	#Release the attack
	if Input.is_action_just_released("player_"+str(id)+"_left_action"):
		charging_left = false
		if has_left_axe:
			has_left_axe = false
			var axe = preload("res://items/axe/real.tscn").instance()
			var lob_dir = aim_dir
			lob_dir.y = charge_l
			axe.set_translation(get_translation() + lob_dir)
			axe.set_rotation(get_node("viking").get_rotation())
			axe.set_target(target_L,charge_l)
			axe.set_angular_velocity(axe.get_transform().basis  * Vector3(3,2,1))
			axe.set_player_id(id)
			axe.set_particle_material(guide_material)
			get_node("../../items").add_child(axe)
			var node = get_node("viking/Armature/Skeleton/hand_L/axe").queue_free()
			get_node("SamplePlayer2D").play("throw")
		charge_l = 0
		target_L = null

		#Unequip the left axe and create a "throwing axe" object
	if Input.is_action_just_released("player_"+str(id)+"_right_action"):
		charging_right = false
		if has_right_axe:
			has_right_axe = false
			var axe = preload("res://items/axe/real.tscn").instance()
			var lob_dir = aim_dir
			lob_dir.y = charge_r
			axe.set_translation(get_translation() + lob_dir)
			axe.set_rotation(get_node("viking").get_rotation())
			axe.set_target(target_R,charge_r)
			axe.set_angular_velocity(axe.get_transform().basis  * Vector3(3,2,1))
			axe.set_player_id(id)
			axe.set_particle_material(guide_material)
			get_node("../../items").add_child(axe)
			get_node("viking/Armature/Skeleton/hand_R/axe").queue_free()
			get_node("SamplePlayer2D").play("throw")
		charge_r = 0
		target_R = null

func give_axe(axe):
	if not axe.can_pick_up:
		false
	if has_left_axe and has_right_axe:
		return false

	if not has_right_axe:
		equip_axe("R")
		has_right_axe = true
		axe.can_pick_up = false
		return true

	elif not has_left_axe:
		equip_axe("L")
		has_left_axe = true
		axe.can_pick_up = false
		return true
