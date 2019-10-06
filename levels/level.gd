extends Node2D

const PANTS = preload("res://collectibles/pants.tscn")
const HAT = preload("res://collectibles/hat.tscn")
const TORSO = preload("res://collectibles/torso.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	events.connect("attack", self, "attack")
	pass # Replace with function body.

func attack(item, position):
	var instance
	if item == 'pants':
		instance = PANTS.instance()
	elif item == 'torso':
		instance = TORSO.instance()
	elif item == 'hat':
		instance = HAT.instance()
	
	if instance:		
		instance.makeProjectile()
		$projectiles.add_child(instance)
		instance.global_transform.origin = position
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
