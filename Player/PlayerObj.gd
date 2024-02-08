extends Area2D

@export var Projectile : PackedScene
@export var speed = 0.0

@onready var screen_size
@onready var SoundController = get_parent().get_node("SoundController")

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	
	move(delta)
	
	if Input.is_action_just_pressed("ui_fire_bullet"):
		shoot()

func shoot():
	if $Sprite2D.visible:
		var projectile = Projectile.instantiate()
		get_parent().add_child(projectile)
		projectile.transform = $Cannon.global_transform
		projectile = null

func _on_area_entered(area):
	if area.is_in_group("Asteroid"):
		if $Sprite2D.visible:
			$Sprite2D.visible = false
			SoundController.play_sound(SoundController.SoundType.PLAYER_DEATH)
			$AnimatedSprite2D.visible = true
			$AnimatedSprite2D.play()

func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.visible = false
	queue_free()

func move(delta):
	var velocity = Vector2.ZERO
	
	if $Sprite2D.visible:
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
		velocity = velocity.normalized() * speed * delta
		position += velocity
		position = position.clamp($Sprite2D.frame_coords, screen_size)
		
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - global_position).normalized()
		var angle = atan2(direction.x, -direction.y)
		rotation = angle
