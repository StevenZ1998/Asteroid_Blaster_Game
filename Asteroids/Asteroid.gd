extends Area2D

signal off_screen
signal asteroid_destroyed

@export var velocity = Vector2.ZERO
@export var speed = randi_range(180, 210)

@onready var randomInt = randi_range(1, 2)
@onready var randomVelocityX = randf_range(.4, 1.5)
@onready var randomVelocityY = randf_range(.4, 1.5)
@onready var rotation_Speed = 0.0

@onready var screen_size = get_viewport_rect().size
@onready var asteroid

func _ready():
	generate_asteroid()

func _process(delta):
	position += velocity * delta 
	rotate(rotation_Speed / PI)

func _on_area_entered(area):
	if area.is_in_group("Projectile"):
		var soundController = get_parent().get_node("SoundController")
		soundController.play_sound(soundController.SoundType.ASTEROID_DESTROYED)
		asteroid_destroyed.emit()
		queue_free()

func generate_asteroid():
	
	rotation_Speed = randf_range((PI / 32), (PI / 16))
	
	match randomInt:
		1:
			asteroid = load("res://Asteroids/Asteroid1/AsteroidOne.tscn").instantiate()
			add_child(asteroid)
		2:
			asteroid = load("res://Asteroids/Asteroid2/AsteroidTwo.tscn").instantiate()
			add_child(asteroid)
	
	var sprite = get_node("Asteroid/Sprite2D")
	
	var x = 0
	var y = 0
	var side = randi() % 4  # Randomly select a side
	
	var sprite_width = sprite.texture.get_width()
	var sprite_height = sprite.texture.get_height()
		
	match side:
		0:  # Top side
			x = randf_range(0, screen_size.x)
			y = -sprite_height
		1:  # Bottom side
			x = randf_range(0, screen_size.x)
			y = screen_size.y + sprite_height
		2:  # Left side
			x = -sprite_width
			y = randf_range(0, screen_size.y)
		3:  # Right side
			x = screen_size.x + sprite_width
			y = randf_range(0, screen_size.y)
			
	position = Vector2(x, y)
			
	# Move the asteroids towards the center of the screen
	var target_position = Vector2(screen_size.x / 2, screen_size.y / 2)
	var direction = (target_position - position).normalized()
	
	var collisionShape = CollisionPolygon2D.new()
	collisionShape.polygon = asteroid.get_node("CollisionPolygon2D").polygon
	add_child(collisionShape)
	
	velocity.x = randomVelocityX * speed * direction.x
	velocity.y = randomVelocityY * speed * direction.y

func _on_visible_on_screen_notifier_2d_screen_exited():
	if $Timer.is_stopped():
		queue_free()

func _on_child_entered_tree(node):
	if node.is_in_group("Timer"):
		node.wait_time = 2.0
