extends Node2D

const SUCCESS_MESSAGE = preload("res://SuccessMessage.tscn")

var current_level = 0
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
		level_finished()


func level_finished():
	print("level finished")
	print("level finished")
	get_tree().paused = true
	var success_message = SUCCESS_MESSAGE.instance()
	get_tree().current_scene.add_child(success_message)
	success_message.find_node("SuccessPopup").show()


func start_next_level():
	start_level(current_level + 1)


func start_level(levelNo):
	buttons = []
	targets = []
	bot_looking_for_target = null
	plan_mode = true
	current_level = levelNo
	var levelName = "res://levels/Level" + ("%02d" % levelNo) + ".tscn"
	var file = File.new()
	if file.file_exists(levelName):
		get_tree().change_scene(levelName)
	else:
		get_tree().change_scene("res://LevelSelect.tscn")
	get_tree().paused = false


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
