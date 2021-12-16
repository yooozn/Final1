extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rng = RandomNumberGenerator.new()
var target = false
var player = null
var health = 5
onready var _anim_player = get_parent().get_node("AnimationPlayer")
onready var shader = $AnimatedSprite.material
onready var TweenNode = $Tween
var state
var canDamage = false
var inRange = false
var immunity = false
var direction = null

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	_anim_player.play("Idle")


func _process(delta):
	if player:
		target = player.position
	if health == 0:
		queue_free()
	if canDamage == true and inRange == true and immunity == false:
		player.damage(1)
		canDamage = false
		immunity = true
		yield(get_tree().create_timer(1),"timeout")
		immunity = false
		if inRange == true:
			canDamage = true
		else:
			canDamage = false
	if state == 'idle':
		state = 'attacking'
#		yield(get_tree().create_timer(2),"timeout")
		print("attacking")
		var random = rng.randi_range(1,2)
		if random == 1:
			if (target.x - $AnimatedSprite.position.x) > 1:
				position = (target + Vector2(-400, -400))
				_anim_player.play("AppearUp")
				direction = 'right'
				print("right")
			elif (target.x - $AnimatedSprite.position.x) < 1:
				position = (target + Vector2(-1000, -400))
				_anim_player.play("AppearUpFlip")
				direction = 'left'
				print("left")
		elif random == 2:
			if (target.x - $AnimatedSprite.position.x) > 1:
				position = (target + Vector2(-400, -400))
				_anim_player.play("AppearDown")
				direction = 'right'
				print("right")
			elif (target.x - $AnimatedSprite.position.x) < 1:
				position = (target + Vector2(-1000, -400))
				_anim_player.play("AppearDownFlip")
				direction = 'left'
				print("left")
		
		

func _on_Detection_Range_body_entered(body):
	if body.is_in_group("Player"):
		$"Detection Range/CollisionShape2D".set_deferred("disabled", true)
		player = body
		_anim_player.play("Start")
		yield(get_tree().create_timer(2.3),"timeout")
		_anim_player.play("DisappearUp")
		state = 'idle'
		print("detectionRange")

func damage(damage):
	health -= 1
	shader.set_shader_param("flash_modifier", 1)
	yield(get_tree().create_timer(.07),"timeout")
	shader.set_shader_param("flash_modifier", 0)


func _on_Boss_body_entered(body):
	if body.is_in_group("Player"):
		canDamage = true
		inRange = true


func _on_Boss_body_exited(body):
	if body.is_in_group("Player"):
		inRange = false

func _AppearUp():
	if direction == 'right':
		TweenNode.interpolate_property(self, "position", position, (position + Vector2(-70, -150)), .3,Tween.TRANS_LINEAR,Tween.EASE_IN)
		TweenNode.start()
		yield(get_tree().create_timer(.5),"timeout")
		_Transform()
		_anim_player.play("Attack1 Right")
	elif direction == 'left':
		TweenNode.interpolate_property(self, "position", position, (position + Vector2(70, -150)), .3,Tween.TRANS_LINEAR,Tween.EASE_IN)
		TweenNode.start()
		yield(get_tree().create_timer(.5),"timeout")
		_Transform()
		_anim_player.play("Attack1")
#	if !_anim_player.current_animation == "Attack1":
#		state = 'idle'
#		print("appearup")
#	elif !_anim_player.current_animation == "Attack1 Right":
#		state = 'idle'
	yield(get_tree().create_timer(1),"timeout")
	print("start")
	state = 'idle'

func _AppearDown():
	if direction == 'right':
		TweenNode.interpolate_property(self, "position", position, (position + Vector2(-70, 150)), .3,Tween.TRANS_LINEAR,Tween.EASE_IN)
		TweenNode.start()
		yield(get_tree().create_timer(.5),"timeout")
		_Transform()
		_anim_player.play("Attack2 Right")
		yield(get_tree().create_timer(.5),"timeout")
		TweenNode.interpolate_property(self, "position", position, (position + Vector2(-1000,-600)), .1, Tween.TRANS_LINEAR,Tween.EASE_IN)
		TweenNode.start()
	elif direction == 'left':
		TweenNode.interpolate_property(self, "position", position, (position + Vector2(70, 150)), .3,Tween.TRANS_LINEAR,Tween.EASE_IN)
		TweenNode.start()
		yield(get_tree().create_timer(.5),"timeout")
		_Transform()
		_anim_player.play("Attack2")
		yield(get_tree().create_timer(.5),"timeout")
		TweenNode.interpolate_property(self, "position", position, (position + Vector2(1000,-600)), .7,Tween.TRANS_LINEAR,Tween.EASE_IN)
		TweenNode.start()
#	if !_anim_player.current_animation == "Attack1":
#		state = 'idle'
#		print("appearup")
#	elif !_anim_player.current_animation == "Attack1 Right":
#		state = 'idle'
	yield(get_tree().create_timer(1.5),"timeout")
	print("start")
	state = 'idle'

func _BlinkUp():
	if direction == 'right':
		TweenNode.interpolate_property(self, "position", position, (position + Vector2(-70, -150)), .3,Tween.TRANS_LINEAR,Tween.EASE_IN)
		TweenNode.start()
	elif direction == 'left':
		TweenNode.interpolate_property(self, "position", position, (position + Vector2(70, -150)), .3,Tween.TRANS_LINEAR,Tween.EASE_IN)
		TweenNode.start()

func _Transform():
	if direction == 'right':
		self.position = position + Vector2(-100, 0)
	elif direction == 'left':
		self.position = position - Vector2(-100,0)

func _TransformReset():
	if direction == 'right':
		self.position = position + Vector2(100,0)
	elif direction == 'left':
		self.position = position - Vector2(100,0)

func _idle():
	state = 'idle'
