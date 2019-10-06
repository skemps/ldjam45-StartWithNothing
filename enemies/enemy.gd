extends Area2D

export var canBeDestroyed = true

func _ready():
	pass

func _physics_process(delta):
	if self.monitoring:
		var overlappings = get_overlapping_bodies()
		if overlappings:
			self.monitoring = false
			events.emit_signal("playerDied")
			
		overlappings = get_overlapping_areas()
		if overlappings:
			self.monitoring = false
			sound.playSound('assets/sounds/hit.wav')
			self.queue_free()
