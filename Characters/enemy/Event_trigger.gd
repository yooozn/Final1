extends Area2D

export var group = 'Null'
export var Event = 'Null'
export var Turn = false
export var Jump = false
export var Damage = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	
	if body.is_in_group(group):
		body.damage(1)
	print(body)
	pass # Replace with function body.
