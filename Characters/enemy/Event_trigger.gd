extends Area2D

export var group = 'Null'
export var Event = 'Null'
export var Turn = false
export var Jump = false
export var Damage = false
var health = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(Area2D):
#	if body.is_in_group(group):
	
#		if Damage == true:
#			body.damage(1)
#		if Damage == false:
#			body.damage(-1)
#	print(body)

	if Area2D.is_in_group(group):
		Area2D.damage(1)
	print('enemy')
	pass # Replace with function body.

func damage(damage):
	print(damage)
	health -= 1
	if health == 0: 
		queue_free()
#	$Effects._damage()
	pass



