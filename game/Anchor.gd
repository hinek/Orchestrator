extends StaticBody2D

const EXTENT = 16


export var is_possible_target = true


func _ready():
	if is_possible_target:
		CentralHub.register_target(self)


func _process(delta):
	if Input.is_action_just_pressed("select"):
		var pos = get_local_mouse_position()
		if abs(pos.x) < EXTENT && abs(pos.y) < EXTENT:
			handle_mouse_click()


func handle_mouse_click():
	CentralHub.element_clicked(self)


func show_select_target_indicator():
	$SelectTarget.show()

func hide_select_target_indicator():
	$SelectTarget.hide()


#why doesn't this work?
func _on_Anchor_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			CentralHub.element_clicked(self)
