extends Node2D

const EXTENT = 16

onready var start_stop_sprite = $StartStop/Sprite


func _ready():
	pass # Replace with function body.


func _process(delta):
	start_stop_sprite.frame = 0 if CentralHub.plan_mode else 1
	if Input.is_action_just_pressed("select"):
		var pos = get_local_mouse_position()
		if pos.x < 0 && pos.x > -32 && abs(pos.y) < EXTENT:
			handle_startstop_click()
		elif pos.x > 0 && pos.x < 32 && abs(pos.y) < EXTENT:
			handle_reset_click()


func handle_startstop_click():
	if CentralHub.plan_mode:
		CentralHub.start_execution()
	else:
		CentralHub.return_to_plan_mode()


func handle_reset_click():
	CentralHub.reset_level()
