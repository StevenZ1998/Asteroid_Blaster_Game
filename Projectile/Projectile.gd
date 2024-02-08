extends Area2D

signal blaster_fired

var frame_count = 4  # Total number of frames in the animation
var current_frame = 0
var frame_duration = 0.125  # Duration for each frame (adjust as needed)
var timer = 0
var speed = 750
var sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var soundController = get_parent().get_node("SoundController")
	soundController.play_sound(soundController.SoundType.BLASTER_FIRED)
	sprite = $Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if timer > frame_duration:
		timer -= frame_duration
		current_frame = (current_frame + 1) % frame_count
		sprite.frame = current_frame
		
func _physics_process(delta):
	position += transform.x * speed * delta

func _on_area_entered(area):
	if area.is_in_group("World_Boundry") || area.is_in_group("Asteroid"):
		queue_free()
