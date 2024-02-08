extends Node

@export var main_music_volume = 0.0
@export var game_sounds_volume = 0.0

@export var Blaster_Sound : PackedScene
@export var Asteroid_Destroyed_Sound: PackedScene
@export var Player_Death_Sound: PackedScene

var music_being_played

enum SoundType {
	ASTEROID_DESTROYED,
	BLASTER_FIRED,
	GAME_MUSIC,
	MAIN_MUSIC,
	PLAYER_DEATH,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_sound(sound: SoundType):
	match sound:
		SoundType.ASTEROID_DESTROYED:
			var asteroid_destroyed_sound = Asteroid_Destroyed_Sound.instantiate()
			asteroid_destroyed_sound.volume_db = game_sounds_volume
			get_node("AsteroidSounds").add_child(asteroid_destroyed_sound)
			asteroid_destroyed_sound = null
			
		SoundType.BLASTER_FIRED:
			var blaster_sound = Blaster_Sound.instantiate()
			blaster_sound.volume_db = game_sounds_volume
			get_node("ProjectileSounds").add_child(blaster_sound)
			blaster_sound = null
			
		SoundType.GAME_MUSIC:
			music_being_played.stop()
			music_being_played = $GameMusic/Game_Music
			music_being_played.play()
			music_being_played.volume_db = main_music_volume
			
		SoundType.MAIN_MUSIC:
			if music_being_played:
				music_being_played.stop()
			
			music_being_played = $GameMusic/Main_Music
			music_being_played.play()
			music_being_played.volume_db = main_music_volume
			
		SoundType.PLAYER_DEATH:
			var player_death_sound = Player_Death_Sound.instantiate()
			player_death_sound.volume_db = game_sounds_volume
			$PlayerSounds.add_child(player_death_sound)
			player_death_sound = null
		
		
