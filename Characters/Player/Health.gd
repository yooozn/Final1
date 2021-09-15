extends CanvasLayer

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_health_update(health_):
	print('test')
	if health_ == 5:
		$"1".visible = true
		$"2".visible = true
		$"3".visible = true
		$"4".visible = true
		$"5".visible = true
	if health_ == 4:
		$"1".visible = true
		$"2".visible = true
		$"3".visible = true
		$"4".visible = true
		$"5".visible = false
	if health_ == 3:
		$"1".visible = true
		$"2".visible = true
		$"3".visible = true
		$"4".visible = false
		$"5".visible = false
	if health_ == 2:
		$"1".visible = true
		$"2".visible = true
		$"3".visible = false
		$"4".visible = false
		$"5".visible = false
	if health_ == 1:
		$"1".visible = true
		$"2".visible = false
		$"3".visible = false
		$"4".visible = false
		$"5".visible = false
	if health_ == 0:
		$"1".visible = true
		$"2".visible = false
		$"3".visible = false
		$"4".visible = false
		$"5".visible = false
	
	pass # Replace with function body.
