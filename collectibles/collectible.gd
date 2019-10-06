extends Area2D

class_name Collectible
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 0
var item = 'not selected'
var lifetime = 0.7
var projectile = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#
#	pass
func makeProjectile():
	self.set_collision_layer_bit(1, false)
	self.set_collision_layer_bit(5, false)
	
	self.set_collision_mask_bit(0, false)
	self.set_collision_mask_bit(2, true)
	self.set_collision_mask_bit(4, true)
	
	self.speed = 2000
	projectile = true
	
func _physics_process(delta):
	if speed > 0:
		self.global_position.x += speed * delta
		self.rotation_degrees += delta * 1000
		lifetime -= delta
		if lifetime <= 0.0:
			self.queue_free()
		
	if self.monitoring:
		if !projectile:
			var overlappings = get_overlapping_bodies()
			if overlappings:
				self.monitoring = false
				events.emit_signal("itemPickedUp", item)
				self.queue_free()
				sound.playSound('assets/sounds/pickUp.wav')
		else:
			var overlappings = get_overlapping_areas()
			if overlappings:
				self.monitoring = false
				self.queue_free()
		