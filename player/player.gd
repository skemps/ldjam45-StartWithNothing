extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hSpeed = 0
var hMaxSpeed = 500
var hAcceleration = 500

var vSpeed = 0
var vMaxSpeed = 1000
var vAcceleration = 3000
var jumpSpeed = -1000
var midAir = true

var running = false
var itemList = []

var state = 'idle'
var frame = 0
var frameTimeout = 0.0

var pantsOffset = 0
var torsoOffset = 0
var showCloud = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	events.connect("itemPickedUp", self, "itemPickedUp")
	pass # Replace with function body.
	
func itemPickedUp(item):
	print(item, ' picked up')
	for itemTmp in itemList:
		if itemTmp == item:
			return 
			
	if item == 'pants':
		pantsOffset = 4
		$censored.visible = false
	elif item == 'torso':
		torsoOffset = 4
	elif item == 'hat':
		$hat.visible = true
		
	itemList.append(item)
	events.emit_signal("itemsAvailable", itemList)
	
func _input(event):
	if (state == 'running'):
		if is_on_floor() && event.is_action_pressed("jump"):
			vSpeed = jumpSpeed
			midAir = true
			sound.playSound('assets/sounds/jump.wav')
			
	if (state == 'running'):
		if event.is_action_pressed("attack"):
			if itemList.empty():
				$clouds/nothing.visible = false
				$clouds/what.visible = false
				$clouds/freezing.visible = false
				$clouds/noway.visible = false
				showCloud = 1.5
				var rand = randf()
				if rand < 0.50:
					$clouds/what.visible = true
				else:
					$clouds/nothing.visible = true
			if !itemList.empty():
				if $warning.visible:
					var item = itemList.pop_back()
					events.emit_signal("attack", item, self.global_position)
					events.emit_signal("itemsAvailable", itemList)
				else:
					$clouds/nothing.visible = false
					$clouds/what.visible = false
					$clouds/freezing.visible = false
					$clouds/noway.visible = false
					showCloud = 1.5
					var rand = randf()
					if rand < 0.50:
						$clouds/freezing.visible = true
					else:
						$clouds/noway.visible = true
				
			var pants = false
			var torso = false
			var hat = false
			var shoes = false
			var shorts = false
			
			for item in itemList:
				if item == 'pants':
					pants = true
				elif item == 'torso':
					torso = true
				elif item == 'shoes':
					shoes = true
				elif item == 'shorts':
					shorts = true
				elif item == 'hat':
					hat = true
					
			if !pants:
				pantsOffset = 0
				$censored.visible = true
			if !torso:
				torsoOffset = 0
			if !hat:
				$hat.visible = false

func _process(delta):
	
	if showCloud > 0.0:
		showCloud -= delta
		if showCloud <= 0.0:
			$clouds/nothing.visible = false
			$clouds/what.visible = false
			$clouds/freezing.visible = false
			$clouds/noway.visible = false
		
	if (state == 'running'):
		frameTimeout -= delta
		if frameTimeout <= 0.0:
			frameTimeout = 0.15
			frame += 1
			frame = frame % 4
			$torsoNaked.frame = frame + torsoOffset
			$legsNaked.frame = frame + pantsOffset
			$headNaked.frame = frame
		
		if running && hSpeed < hMaxSpeed:
			hSpeed += delta * hAcceleration
			if hSpeed > hMaxSpeed:
				hSpeed = hMaxSpeed
				
		if midAir && vSpeed < vMaxSpeed:
			vSpeed += vAcceleration * delta
			
	
func _physics_process(delta):
	if (state == 'running'):
		self.move_and_slide(Vector2(hSpeed, vSpeed), Vector2(0, -1))

