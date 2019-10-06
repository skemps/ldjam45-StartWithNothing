extends Node2D

const LEVEL_1 = preload("res://levels/Level_1.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var currentLevel
var loadLevelTimeout = 0.0
var enemiesTimeout = 0.0

var warningTimer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	events.connect("playerDied", self, "playerDied")
	events.connect("levelCompleted", self, "levelCompleted")
	events.connect("restartPressed", self, "restartPressed")

	currentLevel = LEVEL_1.instance()
	self.add_child(currentLevel)
	
	sound.playSound('assets/sounds/music1.ogg')

func _process(delta):
	$background.global_transform.origin.x = $camera.global_transform.origin.x
	if loadLevelTimeout > 0.0:
		loadLevelTimeout -= delta
		if loadLevelTimeout <= 0.0:
			currentLevel = LEVEL_1.instance()
			self.add_child(currentLevel)
			
			$player.pantsOffset = 0
			$player/censored.visible = true
			$player.torsoOffset = 0
			$player/hat.visible = false
			$player.state = 'idle'
			$player.visible = true
			$player.running = false
			$player/warning.visible = false
			$player.global_transform.origin = currentLevel.find_node('start').global_transform.origin
	
			$camera.followPlayer = true
			$camera.global_transform.origin.x = 640
			$camera.global_transform.origin.y = 360
			return
			
			
	if $player.running && self.currentLevel != null:
		enemiesTimeout -= delta
		$player/warning.rotate( PI/ 90)
		warningTimer += delta * 10.0
		$player/warning.scale.x  = 1.2 + 0.3 * sin(warningTimer)
		$player/warning.scale.y = $player/warning.scale.x
		if enemiesTimeout < 0.0:
			var visibleBefore = $player/warning.visible
			$player/warning.visible = false
			enemiesTimeout = 0.05
			for enemy in self.currentLevel.find_node('enemies').get_children():
				if abs(enemy.global_transform.origin.x - $player.global_transform.origin.x)  < 700:
					if enemy.global_transform.origin.x > $player.global_transform.origin.x:
						$player/warning.visible = true
						if !visibleBefore:
							sound.playSound('assets/sounds/alert.wav')
						break

func restartPressed():
	if currentLevel:
		currentLevel.queue_free()
		currentLevel = null
		loadLevelTimeout = 1.0
		events.emit_signal("restarted")
		$player.itemList = []
		events.emit_signal("itemsAvailable", $player.itemList)
				
func playerDied():
	sound.playSound('assets/sounds/gameOver.wav')
	$player.state = 'dead'
	$player.visible = false
	$player.running = false
	$player.global_transform.origin.x = -1000
	$player.global_transform.origin.y = -1000
	$player/warning.visible = false
	
func levelCompleted():
	print('Level completed')
	$camera.followPlayer = false
	$player.state = 'dead'
	$player.visible = false
	$player.running = false
	$player.global_transform.origin.x = -1000
	$player.global_transform.origin.y = -1000


func _input(event):
	if ($player.state == 'idle'):
		if event.is_action_pressed("attack"):
			$player.state = 'running'
			$player.running = true
	pass
