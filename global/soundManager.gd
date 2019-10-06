extends Node
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var sounds = {}

# Called when the node enters the scene tree for the first time.
func _ready():
#	print("sound loaded")
	pass # Replace with function body.

func playSound(sound):
	if !sounds.has(sound):
		var player = AudioStreamPlayer.new()
		add_child(player)
		player.stream = load("res://" + sound)
		sounds[sound] = player
	sounds[sound].play()