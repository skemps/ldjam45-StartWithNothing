extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if self.monitoring:
		var overlappings = get_overlapping_bodies()
		if overlappings:
			self.monitoring = false
			events.emit_signal("levelCompleted")
