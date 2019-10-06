extends Control

const TROUSERS_ICON = preload("res://assets/icons/trousers.png")
const TORSO_ICON = preload("res://assets/icons/torso.png")
const HAT_ICON = preload("res://assets/icons/hat.png")

var items = []

var loadingTimeout = 0.0
var hidingTimeout = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	events.connect("itemsAvailable", self, "itemsAvailable")
	events.connect("playerDied", self, "gameOver")
	events.connect("restarted", self, "restarted")
	events.connect("levelCompleted", self, "levelCompleted")
	
	get_node("gameOver/restartButton").connect("pressed", self, "buttonRestartPressed")
	get_node("endScreenComplete/restartButton2").connect("pressed", self, "buttonRestartPressed")
	get_node("endScreenFailed/restartButton3").connect("pressed", self, "buttonRestartPressed")
	pass
	
func _process(delta):
	if hidingTimeout > 0.0:
		self.hidingTimeout -= delta
		$loadingScreen.modulate.a -= delta * 2
		if hidingTimeout <= 0.0:
			$loadingScreen.visible = false
			
	if loadingTimeout > 0.0:
		self.loadingTimeout -= delta
		$loadingScreen.modulate.a += delta * 5.0
		
		if $loadingScreen.modulate.a > 1.0:
			$loadingScreen.modulate.a = 1.0
		
		if loadingTimeout <= 0.0:
			hidingTimeout = 0.5

func levelCompleted():
	if items.empty():
		$endScreenComplete.visible = true	
	else:
		$endScreenFailed.visible = true
		$endScreenFailed/pants.visible = false
		$endScreenFailed/hat.visible = false
		$endScreenFailed/torso.visible = false
		for item in items:
			if item == 'pants':
				$endScreenFailed/pants.visible = true
			elif item == 'torso':
				$endScreenFailed/torso.visible = true
			elif item == 'hat':
				$endScreenFailed/hat.visible = true
		
		
func restarted():
	$gameOver.visible = false
	$endScreenComplete.visible = false
	$endScreenFailed.visible = false
	
func buttonRestartPressed():
	events.emit_signal("restartPressed")
	loadingTimeout = 0.5
	$loadingScreen.visible = true
	$loadingScreen.modulate.a = 0.0
	
func gameOver():
	$gameOver.visible = true
	
func itemsAvailable(items):
	for child in $HBoxContainer.get_children():
		child.queue_free()
	
	self.items = items
	for item in items:
		if item == 'pants':
			var texRect = TextureRect.new()
			texRect.texture = TROUSERS_ICON
			$HBoxContainer.add_child(texRect)
		elif item == 'torso':
			var texRect = TextureRect.new()
			texRect.texture = TORSO_ICON
			$HBoxContainer.add_child(texRect)
		elif item == 'hat':
			var texRect = TextureRect.new()
			texRect.texture = HAT_ICON
			$HBoxContainer.add_child(texRect)

