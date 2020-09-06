extends KinematicBody2D

const EXTENT = 16
const MAX_VELOCITY = 50

const CMD_NONE = 0
const CMD_GO_NORTH = 1
const CMD_GO_EAST = 2
const CMD_GO_SOUTH = 3
const CMD_GO_WEST = 4
const CMD_WALK_TOWARDS = 5
const CMD_WALK_AWAY_FROM = 6
const CMD_CIRCLE_CLOCKWISE = 7
const CMD_CIRCLE_COUNTER = 8


var command = CMD_NONE
var target = null setget set_target
var motion = Vector2.ZERO

export var restrict_commands = 8

onready var sprite = $Sprite
onready var animation = $AnimationPlayer


func _ready():
	if (restrict_commands < CMD_GO_NORTH):
		$PopupMenu/VBoxContainer/GoNorth.hide()
	if (restrict_commands < CMD_GO_EAST):
		$PopupMenu/VBoxContainer/GoEast.hide()
	if (restrict_commands < CMD_GO_SOUTH):
		$PopupMenu/VBoxContainer/GoSouth.hide()
	if (restrict_commands < CMD_GO_WEST):
		$PopupMenu/VBoxContainer/GoWest.hide()
	if (restrict_commands < CMD_WALK_TOWARDS):
		$PopupMenu/VBoxContainer/WalkTowards.hide()
	if (restrict_commands < CMD_WALK_AWAY_FROM):
		$PopupMenu/VBoxContainer/WalkAwayFrom.hide()
	if (restrict_commands < CMD_CIRCLE_CLOCKWISE):
		$PopupMenu/VBoxContainer/CircleClockwise.hide()
	if (restrict_commands < CMD_CIRCLE_COUNTER):
		$PopupMenu/VBoxContainer/CircleCounter.hide()
	pass # Replace with function body.


func _process(delta):
	if CentralHub.plan_mode:
		animation.play("idle")
		if Input.is_action_just_pressed("select"):
			var pos = get_local_mouse_position()
			if abs(pos.x) < EXTENT && abs(pos.y) < EXTENT:
				handle_mouse_click()
			else:
				handle_mouse_unclick()
	else:
		if command == CMD_NONE:
			return
		if command == CMD_GO_NORTH:
			motion = Vector2(0, -MAX_VELOCITY)
		elif command == CMD_GO_EAST:
			motion = Vector2(MAX_VELOCITY, 0)
		elif command == CMD_GO_SOUTH:
			motion = Vector2(0, MAX_VELOCITY)
		elif command == CMD_GO_WEST:
			motion = Vector2(-MAX_VELOCITY, 0)
		elif target != null:
			var target_vector = (target.position - self.position).normalized()
			if command == CMD_WALK_TOWARDS:
				motion = target_vector * MAX_VELOCITY
			if command == CMD_WALK_AWAY_FROM:
				motion = target_vector * -MAX_VELOCITY
			if command == CMD_CIRCLE_CLOCKWISE:
				motion = Vector2(target_vector.y, -target_vector.x) * MAX_VELOCITY
			if command == CMD_CIRCLE_COUNTER:
				motion = Vector2(-target_vector.y, target_vector.x) * MAX_VELOCITY
		if (motion != Vector2.ZERO):
			animation.play("walk")
			sprite.flip_h = motion.x < 0
		motion = move_and_slide(motion)


func handle_mouse_click():
	var handled = CentralHub.element_clicked(self)
	if !handled:
		$PopupMenu.rect_position = Vector2(self.position.x + EXTENT, self.position.y)
		$PopupMenu.show()


func handle_mouse_unclick():
	$PopupMenu.hide()


func set_command(value):
	command = value
	target = null
	$PopupMenu.hide()
	if command < CMD_WALK_TOWARDS:
		$CurrentCommand.frame = command + 1
	else:
		CentralHub.bot_looking_for_target = self
		
func set_target(value):
	target = value
	$CurrentCommand.frame = command + 1

func _on_None_pressed():
	set_command(CMD_NONE)

func _on_GoNorth_pressed():
	set_command(CMD_GO_NORTH)

func _on_GoEast_pressed():
	set_command(CMD_GO_EAST)

func _on_GoSouth_pressed():
	set_command(CMD_GO_SOUTH)

func _on_GoWest_pressed():
	set_command(CMD_GO_WEST)

func _on_WalkTowards_pressed():
	set_command(CMD_WALK_TOWARDS)

func _on_WalkAwayFrom_pressed():
	set_command(CMD_WALK_AWAY_FROM)

func _on_CircleClockwise_pressed():
	set_command(CMD_CIRCLE_CLOCKWISE)

func _on_CircleCounter_pressed():
	set_command(CMD_CIRCLE_COUNTER)
