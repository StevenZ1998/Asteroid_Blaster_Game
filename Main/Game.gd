extends Node

@export var background: Resource

@onready var player
@onready var spawntimer = $MobTimer
@onready var playertimer = $PlayerTimer
var score = 0

func _ready():
	$SoundController.play_sound($SoundController.SoundType.MAIN_MUSIC)
	$HUD/MainScreen.show()

func _process(delta):
	if playertimer.time_left > 4:
		$HUD/GameHUD/PlayerTimer.text = "Get Ready!"
		$HUD/GameHUD/PlayerTimer.show()
	elif playertimer.time_left < 4 and playertimer.time_left > 0:
		$HUD/GameHUD/PlayerTimer.text = str(int(playertimer.time_left)) + "!"

func add_player():
	player = load("res://Player/PlayerObj.tscn").instantiate()
	player.position = Vector2(320, 180)

func _on_timer_timeout():
	spawntimer.wait_time = randf_range(0.4, 0.8)
	var asteroid = load("res://Asteroids/Asteroid.tscn").instantiate()
	add_child.call_deferred(asteroid)

func _on_asteroid_destroyed():
	score = score + 1
	$HUD/GameHUD/ScoreCounter.text = str(score)

func _on_child_entered_tree(node):
	if node.is_in_group("Asteroid"):
		get_node(node.get_path()).asteroid_destroyed.connect(_on_asteroid_destroyed)
	if node.is_in_group("HUD"):
		$HUD.start_pressed.connect(_on_start_button_pressed)

func start_game():
	playertimer.wait_time = 5
	spawntimer.wait_time = 5
	spawntimer.start()
	playertimer.start()
	for node in get_children():
		if node.is_in_group("Asteroid"):
			node.queue_free()
	add_player()
	score = 0
	$HUD/GameHUD/ScoreCounter.text = str(score)

func _on_child_exiting_tree(node):
	if node.is_in_group("Player"):
		spawntimer.stop()
		$HUD/GameHUD.hide()
		$HUD/DeathScreen/ScoreCounter.text = str(score)
		Input.set_custom_mouse_cursor(null, Input.CURSOR_ARROW, Vector2(0, 0))
		$HUD/DeathScreen.show()

func _on_player_timer_timeout():
	add_child.call_deferred(player)
	$HUD/GameHUD/PlayerTimer.hide()

func _on_start_button_pressed():
	$HUD/MainScreen.hide()
	$HUD/DeathScreen.hide()
	$HUD/GameHUD.show()
	$SoundController.play_sound($SoundController.SoundType.GAME_MUSIC)
	var mouse = load("res://Assets/Crosshair.png")
	var hotspot = Vector2(80, 45)
	Input.set_custom_mouse_cursor(mouse, Input.CURSOR_ARROW, Vector2(80, 45))
	# Input.set_custom_mouse_cursor(hotspot)
	start_game()
