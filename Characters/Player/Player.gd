extends KinematicBody2D

signal grounded_updated(is_grounded)
signal health_update(health_)

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
var can_interupt = true
var can_beHit = true
var is_jumping = false
var is_grounded
#The speed of the player dash
var dash_speed = 200
var jab_num = 1
var jab_connected = false
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
		if can_interupt == true:
			if dir.x == 0:
				if can_move == true:
					$AnimationPlayer.play("Idle")
#		else:
#			dir.x = 0
		
		vel.y = gravity * 0.01
	elif vel.y < term_gravity and can_move == true:
		
		vel.y += gravity * delta
	if vel.y > 10 and can_interupt == true:
		$AnimationPlayer.play("Fall")
	if can_move == true:
		vel.x = dir.x * speed
	if jab_connected == true:
		if $Player_sprite.flip_h == true:
			vel.x = 25.0
		else:
			vel.x = -25.0
	input_stuff()
	move_and_slide(vel * 10, Vector2(0, -1))

func input_stuff():
	dir.x = 0
		#Add gravity
	if Input.is_action_pressed("ui_left"):
		$Player_sprite.flip_h = true
		dir.x = -1.0
		if can_move == true and can_interupt == true:
			if is_on_floor():
				$AnimationPlayer.play("Walk")
				
				
				
	elif Input.is_action_pressed("ui_right"):
		$Player_sprite.flip_h = false
		dir.x = 1.0
		if can_move == true and can_interupt == true:
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
		else: 
			print(self.is_on_floor())
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
	if can_interupt == true:
		
		$AnimationPlayer.stop(true)
	#	$AnimationPlayer.play("Punch")
		print(jab_num)
		if jab_num == 1:
			$AnimationPlayer.play("Punch")
			$Attack_timer.start()
			jab_num += 1
		elif jab_num == 2:
			$AnimationPlayer.play("Punch2")
		$Attack_timer.start()
	can_interupt = false

func damage(damage):
	if can_beHit == true:
		can_beHit = false
		$DamageTimer.start(0.0)
		$sound_damage.play(0.0)
		print(damage)
		health -= damage
		$Effects._damage(self.position)
		health_update()
	pass

func health_update():
	$"Camera2D/Post Processing/Curve/ui/Health/"._on_Player_health_update(health)
	emit_signal("health_updated", health)
	print('current health is ', health)
	pass



func dash():
	$Dash_invun.start()
	can_beHit = false
	partical_make(jump_particles, self.position + Vector2(0, 25))
	$sound_dash.play(0.0)
	$AnimationPlayer.stop(true)
	$AnimationPlayer.play("Dash")
	print("dash")
	$Dash.start()
	can_move = false
	vel.y = -12.0
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
	pass 




func _on_DashLag_timeout():
	print('dashlag')
	can_move = true
	pass 



func _on_AnimationPlayer_animation_finished(anim_name):
	if self.is_on_floor():
		$AnimationPlayer.play("Idle")
	else:
		$AnimationPlayer.play("Jump")
	if anim_name == ('Punch'):
		can_interupt = true
		jab_connected = false
	if anim_name == ('Punch2'):
		jab_num = 1
		can_interupt = true
		jab_connected = false
	pass # Replace with function body.


func _on_Attack_timer_timeout():
	$Attack_timer2.start()
	can_interupt = true
	pass 

func _on_Attack_timer2_timeout():
	jab_num = 1
	pass 


func _on_jump_timer_timeout():
	print('ended')
	jump('down')
	pass 


func _on_Damage_timeout():
	can_beHit = true
	pass # Replace with function body.


func _on_Dash_invun_timeout():
	can_beHit = true
	pass # Replace with function body.


func _on_Attack_body_shape_entered(body_id, body, body_shape, local_shape):
	if body.is_in_group('Enemy'):
		print('collision')
	print(body)
	pass # Replace with function body.


func _on_Attack_area_entered(area):
	if area.is_in_group('Enemy'):
		print('collision')
		area.damage(1)
		jab_connected = true
	print(area)
	
	pass

func set_limit(left, right, top, bottom):
	$Camera2D.limit_top = top
	$Camera2D.limit_bottom = bottom
	$Camera2D.limit_left = left
	$Camera2D.limit_right = right
	
	pass
