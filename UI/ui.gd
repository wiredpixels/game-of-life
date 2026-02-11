extends CanvasLayer

@export var world : Node2D

@onready var controls: PanelContainer = $Controls
@onready var instructions: PanelContainer = $Instructions
@onready var label_delay_value: Label = $Controls/MarginContainer/HBoxContainer/LabelDelayValue

func _ready() -> void:
	controls.visible = false
	instructions.visible = false
	label_delay_value.text = str(world.frame_delay_ms)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				draw(world.get_global_mouse_position())
			MOUSE_BUTTON_RIGHT:
				draw(world.get_global_mouse_position(), false)
	elif event is InputEventMouseMotion:
		match event.button_mask :
			MOUSE_BUTTON_MASK_LEFT:
				draw(world.get_global_mouse_position())
			MOUSE_BUTTON_MASK_RIGHT:
				draw(world.get_global_mouse_position(), false)


func draw(gp : Vector2, is_alive : bool = true) -> void:
	world.paused = true
	controls.visible = true
	var cell : Vector2i = world.next_state.local_to_map(world.next_state.to_local(gp))
	world.set_alive(cell, is_alive)

func clear_all() -> void:
	world.clear_all()

func _on_button_close_pressed() -> void:
	instructions.visible = false


func _on_button_unpause_pressed() -> void:
	world.paused = false
	controls.visible = false
	instructions.visible = false


func _on_button_clear_all_pressed() -> void:
	clear_all()

func _on_button_instructions_pressed() -> void:
	instructions.visible = true


func _on_button_plus_pressed() -> void:
	world.add_delay(50)
	label_delay_value.text = str(world.frame_delay_ms)


func _on_button_minus_pressed() -> void:
	world.add_delay(-50)
	label_delay_value.text = str(world.frame_delay_ms)
