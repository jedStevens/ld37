extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var game_duration = 60
var game_time = 0

var last_ham = 0

var last_round = 0

var players = 0

var item_id = 0

var Mead = preload("res://beer.tscn")

var game_over = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	for i in range(2):
		var character = Globals.get("player_"+str(i))
		if character != "Not Playing":
			add_player(character, i)
	
	set_fixed_process(true)
	game_time = 0
	randomize()

func _fixed_process(delta):
	game_time += delta
	var cam = get_node("camera").get_translation()
	
	var sum = Vector3(0,0,0)
	for p in get_node("players").get_children():
		sum += p.get_translation()
	sum = sum / get_node("players").get_child_count()
	cam.x = sum.x *0.75
	get_node("camera").set_translation(cam)
	get_node("camera").look_at(sum, Vector3(0,1,0))
	
	var ui_size = get_viewport().get_rect().size
	get_node("ui").set_size(ui_size)
	ui_size.y = 0
	get_node("ui/hud/players").set_size(ui_size)
	
	
	if game_time > game_duration:
		get_node("ui/CenterContainer/HBoxContainer/timer_lbl").set_text("0")
		end_game()
	else:
		get_node("ui/CenterContainer/HBoxContainer/timer_lbl").set_text(str(ceil(game_duration - game_time)))
		
		#Deploy Mead
		if int(ceil(game_duration - int(game_time))) % 12 == 0 and floor(game_time) > last_round:
			last_round = ceil(game_time)
			var spawns = range(get_node("spawns").get_child_count())
			
			for i in range(floor(players*1.5)):
				var mead = Mead.instance()
				var point = randi()%spawns.size()
				mead.set_translation(get_node("item_spawns").get_child(spawns[point]).get_translation())
				mead.set_name("beer_"+str(item_id))
				item_id += 1 
				spawns.remove(point)
				get_node("items").add_child(mead)
		
		# Deploy Hams
		if int(ceil(game_duration - int(game_time))) % 30 == 0 and floor(game_time) > last_ham:
			last_ham = ceil(game_time)
			var ham = preload("res://ham.tscn").instance()
			var ham_id = floor(get_node("item_spawns").get_child_count() * randf())
			ham.set_translation(get_node("item_spawns").get_child(ham_id).get_translation())
			get_node("items").add_child(ham)
	
	for i in range(get_node("players").get_child_count()):
		get_node("ui/hud/players").get_child(i).update_info(get_node("players").get_child(i))
	
	for p in get_node("players").get_children():
		if p.dead:
			var spawn =  get_node("spawns").get_child(p.id)
			p.set_translation(spawn.get_translation())
			p.respawn()

func end_game():
	if game_over:
		return
	game_over = true
	for p in get_node("players").get_children():
		p.lock =true
	#Write to globals here i guess, results dict?
	var results = {}
	for player in get_node("players").get_children():
		results["player_"+str(player)+"_kills"] = player.kills
		results["player_"+str(player)+"_deaths"] = player.deaths
		results["player_"+str(player)+"_drinks"] = player.drinks
	Globals.set("results", results)
	
	var winner = null
	var scores = []
	
	for p in get_node("players").get_children():
		scores.append(p.drinks)
	
	var highest = scores[0]
	
	for s in scores:
		if s > highest:
			highest = s
	
	if scores.count(highest) > 1:
		get_node("ui/winner_lbl").set_text("Its a draw!")
	else:
		get_node("ui/winner_lbl").set_text("Player "+str(scores.find(highest)+1)+" Wins!")
	
	get_node("AnimationPlayer").play("end_game")

func get_camera():
	return get_node("camera")

func add_player(name, id):
	name = name.to_lower()
	var node = load("res://"+name+".tscn").instance()
	node.set_translation(get_node("spawns").get_child(players).get_translation())
	node.set_player_id(id)
	get_node("players").add_child(node)
	players += 1
	
	var ui_node = load("res://player_hud.tscn").instance()
	ui_node.set_name(name, id)
	get_node("ui/hud/players").add_child(ui_node)

func _on_resetter_body_enter( body ):
	if body.get("id") != null:
		var spawn =  get_node("spawns").get_child(body.id)
		body.set_translation(spawn.get_translation())
		if body.is_in_group("player"):
			body.kill()
	else:
		body.queue_free()

func change_to_character_select():
	get_tree().change_scene("res://character_select.tscn")
