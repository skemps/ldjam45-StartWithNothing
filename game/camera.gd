extends Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player
var followPlayer = true

# Called when the node enters the scene tree for the first time.
func _ready():
	self.player = self.get_parent().find_node('player')
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if followPlayer:
		if self.player.global_transform.origin.x + 350 > self.global_transform.origin.x:
			self.global_transform.origin.x = self.player.global_transform.origin.x + 350
