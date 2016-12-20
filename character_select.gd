extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var characters = ["Slagga", "Yxa", "Svard", "Not Playing"]
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	
	for i in range(2):
		for c in range(3):
			get_node("VBoxContainer/HBoxContainer/VBoxContainer"+str(i+1)+"/p"+str(i+1)+"_char").add_item(characters[c])

func _fixed_process(delta):
	var size = get_viewport().get_rect().size
	set_size(size)
	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://main_menu.tscn")

func _on_play_pressed():
	get_tree().change_scene("res://game.tscn")
	
	for i in range(2):
		var ind = get_node("VBoxContainer/HBoxContainer/VBoxContainer"+str(i+1)+"/p"+str(i+1)+"_char").get_selected()
		var character = characters[ind]
		print("VBoxContainer/HBoxContainer/VBoxContainer"+str(i+1)+"/p"+str(i+1)+"_char  ", ind, " as ", character)
		Globals.set("player_"+str(i), character)