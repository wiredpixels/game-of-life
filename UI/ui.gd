extends CanvasLayer

@export var world : World

@onready var controls: PanelContainer = $Controls
@onready var instructions: PanelContainer = $Instructions
@onready var label_delay_value: Label = $Controls/MarginContainer/VBoxContainer/HBoxContainer2/LabelDelayValue
@onready var button_zoom: Button = $Controls/MarginContainer/VBoxContainer/HBoxContainer/ButtonZoom
@onready var button_move_camera: Button = $Controls/MarginContainer/VBoxContainer/HBoxContainer/ButtonMoveCamera

func _ready() -> void:
	visible = true
	controls.visible = false
	button_zoom.visible = false
	button_move_camera.visible = false
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
		match event.button_mask:
			MOUSE_BUTTON_MASK_LEFT:
				draw(world.get_global_mouse_position())
			MOUSE_BUTTON_MASK_RIGHT:
				draw(world.get_global_mouse_position(), false)

	elif event is InputEventScreenTouch and event.pressed:
		world.is_mobile_player = true
		world.paused = true
		controls.visible = true
		draw(world.get_global_mouse_position())

	elif event is InputEventScreenDrag:
		world.is_mobile_player = true
		world.paused = true
		controls.visible = true
		draw(world.get_global_mouse_position())


func draw(gp : Vector2, is_alive : bool = true) -> void:
	world.paused = true
	controls.visible = true
	if !world.camera_mode_zoom and !world.camera_mode_move:
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

func get_color(id : int) -> Color:
	match id:
		1:
			return Color.RED
		2:
			return Color.BLUE
		3:
			return Color.GREEN
		4:
			return Color.YELLOW
		5:
			return Color.BLACK
	return Color.WHITE


func _on_color_picker_button_color_changed(color: Color) -> void:
	RenderingServer.set_default_clear_color(color)


func _on_color_picker_button_color_color_changed(color: Color) -> void:
	world.tile_map_layer.modulate = color
	world.tile_map_layer_2.modulate = color

func _on_menu_button_bg_color_id_pressed(id : int) -> void:
	var c : Color = get_color(id)


func _on_button_move_camera_toggled(toggled_on: bool) -> void:
	World.get_instance().camera_mode_zoom = false
	World.get_instance().camera_mode_move = toggled_on
	button_zoom.set_pressed_no_signal(false)


func _on_button_zoom_toggled(toggled_on: bool) -> void:
	World.get_instance().camera_mode_move = false
	World.get_instance().camera_mode_zoom = toggled_on
	button_move_camera.set_pressed_no_signal(false)


func _on_controls_visibility_changed() -> void:
	if world != null and world.is_mobile_player:
		button_zoom.visible = true
		button_move_camera.visible = true
		
