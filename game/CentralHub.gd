extends Node2D

var buttons = []
var targets = []
var bot_looking_for_target = null
var plan_mode = true


func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_just_pressed("start") && plan_mode:
		plan_mode = false
	elif Input.is_action_just_pressed("reset") && !plan_mode:
		buttons = []
		targets = []
		bot_looking_for_target = null
		plan_mode = true
		get_tree().reload_current_scene()
	pass


func register_button(button):
	print ("button registered: ", button)
	buttons.append(button)


func button_state_changed(button, is_down):
	if is_down:
		for reg_button in buttons:
			if !reg_button.is_down:
				print(reg_button, " is not down")
				return
		print("level finished")


func register_target(target):
	targets.append(target)
	print ("target registered: ", target)


func element_clicked(element):
	if !plan_mode:
		return true
	var handled = false
	if bot_looking_for_target != null:
		bot_looking_for_target.target = element
		bot_looking_for_target = null
		handled = true
	print (element, " clicked", " and handled" if handled else "")
	return handled
