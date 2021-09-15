extends KinematicBody2D

signal grounded_updated(is_grounded)

#Direction of input from keyboard 
var dir = Vector2()
#The velocity of the player
var vel = Vector2()
#The factor in which the player accelerates 
var acel = 1
#The max speed of the player
var speed = 50
export var health = 3
#The time spent in the air
var jump_time = 0.1
#The jump height of the player
var jump = 100
#The ammount of gravity applied to the player 
var gravity = 180.8
#Terminal velocity 
var term_gravity = 100
#Kinda self explainitory
var can_move = true
var is_jumping = false
var is_grounded
#The speed of the player dash
var dash_speed = 400
var jab_num = 1

#Particles
var jump_particles = preload("res://Characters/Player/Jump_particles.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var was_grounded = is_grounded
	is_grounded = is_on_floor()
	
	if was_grounded == null || is_grounded != was_grounded:
		emit_signal("grounded_updated", is_grounded)
	
	if is_grounded == true:
			#make a fucking state machine you fat fucking bastard
		if $AnimationPlayer.current_animation != 'Punch' or $AnimationPlayer.current_animation != 'Punch2':
			if dir.x == 0:
				if can_move == true:
					$AnimationPlayer.play("Idle")
#		else:
#			dir.x = 0
		
		vel.y -= gravity * 0.01
	elif vel.y < term_gravity:
		vel.y += gravity * delta
	vel.x = dir.x * speed
	input_stuff()
	move_and_slide(vel * 10, Vector2(0, -1))

func input_stuff():
	dir.x = 0
		#Add gravity
	if Input.is_action_pressed("ui_left"):
		$Player_sprite.flip_h = true
		dir.x = -1.0
		if can_move == true:
			if is_on_floor():
				$AnimationPlayer.play("Walk")
				
				
				
	elif Input.is_action_pressed("ui_right"):
		$Player_sprite.flip_h = false
		dir.x = 1.0
		if can_move == true:
			if is_on_floor():
				$AnimationPlayer.play("Walk")
	if Input.is_action_just_pressed("jump"):
		print("jumped")
		jump('up')
#		$AnimationPlayer.play("Jump")
	if Input.is_action_just_released("jump") and vel.y < 0:
		jump('down')
	if Input.is_action_just_pressed("Dash"):
		dash()
	if Input.is_action_just_pressed("attack"):
		attack()

func jump(state):
	if state == 'up':
		if self.is_on_floor():
			partical_make(jump_particles, self.position + Vector2(0, 25))
			$jump_timer.start(jump_time)
			$AnimationPlayer.play("Walk")
			print('is on floor')
			vel.y = -jump
	#		$AnimationPlayer.stop(true)
			$AnimationPlayer.play("Jump")
			print($AnimationPlayer.playback_active)
		if self.is_on_wall():
			partical_make(jump_particles, self.position + Vector2(0, 25))
			$jump_timer.start(jump_time)
			$AnimationPlayer.play("Walk")
			print('is on floor')
			vel.y = -jump
	#		$AnimationPlayer.stop(true)
			$AnimationPlayer.play("Jump")
			print($AnimationPlayer.playback_active)

	if state == 'down':
		if $jump_timer.time_left <= 0:
			if not Input.is_action_pressed("jump"):
				vel.y = 0
func attack():
	$AnimationPlayer.stop(true)
#	$AnimationPlayer.play("Punch")
	print(jab_num)
	if jab_num == 1:
		$AnimationPlayer.play("Punch")
		$Attack_timer.start()
		jab_num += 1
	if jab_num == 2:
		$AnimationPlayer.play("Punch")
		$Attack_timer.start()
	can_move = false

func damage(damage):
	health -= damage
	$Effects._damage()
	health_update()
	pass

func health_update():
	print('current health is ', health)
	pass

func dash():
	partical_make(jump_particles, self.position + Vector2(0, 25))
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

func partical_make(name, position):
	var particle_effect = name.instance()
	particle_effect.position = position
	add_child(particle_effect)

func _on_Dash_timeout():
	print('timeout')
	vel.x = dir.x * speed
	vel.y += gravity * 0.1
	$DashLag.start()
	pass # Replace with function body.




func _on_DashLag_timeout():
	print('dashlag')
	can_move = true
	pass # Replace with function body.



func _on_AnimationPlayer_animation_finished(anim_name):
	if self.is_on_floor():
		$AnimationPlayer.play("Idle")
	else:
		$AnimationPlayer.play("Jump")
	if anim_name == ('Punch'):
		can_move = true
	pass # Replace with function body.


func _on_Attack_timer_timeout():
	$Attack_timer2.start()
	pass # Replace with function body.


func _on_Attack_timer2_timeout():
	jab_num = 1
	pass # Replace with function body.


func _on_jump_timer_timeout():
	print('ended')
	jump('down')
	pass # Replace with function body.
