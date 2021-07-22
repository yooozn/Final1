extends KinematicBody2D


#Direction of input from keyboard 
var dir = Vector2()
#The velocity of the player
var vel = Vector2()
#The factor in which the player accelerates 
var acel = 1
#The max speed of the player
var speed = 30
#The time spent in the air
var jump_time = 0.6 
#The jump height of the player
var jump = 30
#The ammount of gravity applied to the player 
var gravity = 90.8
#Terminal velocity 
var term_gravity = 100
#Kinda self explainitory
var can_move = true
#The speed of the player dash
var dash_speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if can_move == true:
		vel.x = dir.x * speed
		dir.x = 0
		if Input.is_action_pressed("ui_left"):
			dir.x = -1.0
			$Player_sprite.flip_h = true
			#detects if the player is on the ground (idk why but I need to use if on wall instead)
			if is_on_floor():
				$AnimationPlayer.play("Walk")
		elif Input.is_action_pressed("ui_right"):
			dir.x = 1.0
			$Player_sprite.flip_h = false
			#Detects if the player is on the ground (idk why but I need to use if on wall instead)
			if is_on_floor():
				$AnimationPlayer.play("Walk")
		if Input.is_action_just_pressed("jump"):
			print("jumped")
			vel.y = -50
			$AnimationPlayer.stop(true)
			$AnimationPlayer.play("Jump")
#		$AnimationPlayer.play("Jump")
		if Input.is_action_just_released("jump") and vel.y < 0:
			vel.y = 0
		if Input.is_action_just_pressed("Dash"):
			dash()
		if Input.is_action_just_pressed("attack"):
			$AnimationPlayer.stop(true)
			$AnimationPlayer.play("Punch")
		#Add gravity
		if is_on_floor():
			if dir.x == 0:
				$AnimationPlayer.stop()
				$AnimationPlayer.play("Idle")
#			$AnimationPlayer.stop()
			
			vel.y -= gravity * 0.01
		elif vel.y < term_gravity:
			vel.y += gravity * delta
	move_and_slide(vel * 10, Vector2(0, -1))
	

func dash():
	$sound_dash.play(0.0)
	$AnimationPlayer.stop(true)
	$AnimationPlayer.play("Dash")
	print("dash")
	$Dash.start()
	can_move = false
	vel.y = 0
	if $Player_sprite.flip_h == true:
		vel.x = -dash_speed 
	else:
		vel.x = dash_speed 
	pass


func _on_Dash_timeout():
	vel.x = dir.x * speed
	vel.y += gravity * 0.1
	$DashLag.start()
	pass # Replace with function body.



func _on_DashLag_timeout():
	can_move = true
	pass # Replace with function body.



func _on_AnimationPlayer_animation_finished(anim_name):
	$AnimationPlayer.play("Idle")
	pass # Replace with function body.
