extends CenterContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var COLORS = [Color("00B74A"), Color("4811AE"), Color("FFDF00"), Color("FF3100"), Color("000000")]

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func set_name(name, color_id):
	get_node("HBoxContainer/VBoxContainer/name").set("custom_colors/font_color", COLORS[color_id])
	get_node("HBoxContainer/VBoxContainer/name").set_text(name)

func update_info(player):
	set_beer(player.drinks)
	set_hearts(player.health)

func set_beer(c):
	get_node("HBoxContainer/VBoxContainer/HBoxContainer/beer_counter").set_text(str(c))

func set_hearts(c):
	get_node("HBoxContainer/VBoxContainer/HBoxContainer2/heart_counter").set_text(str(c))