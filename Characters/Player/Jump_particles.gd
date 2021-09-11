extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print('particles')
	$Trail.global_position = self.position
	$Dust.position = self.position
	$Dust.set_as_toplevel(1)
	$Dust.emitting = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	print('queue_free')
	queue_free()
	pass # Replace with function body.
