extends Area2D

var is_down = false

func _ready():
	CentralHub.register_button(self)


func _on_Button_body_entered(body):
	$AnimationPlayer.play("enable")
	is_down = true
	CentralHub.button_state_changed(self, is_down)


func _on_Button_body_exited(body):
	$AnimationPlayer.play_backwards("enable")
	is_down = false
	CentralHub.button_state_changed(self, is_down)
