extends Camera2D

@export var move_speed: float = 300.0
@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 128.0

func _process(delta: float) -> void:
	var direction := Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		position += direction * move_speed * delta
	
	_handle_zoom()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			apply_zoom(1, 4)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			apply_zoom(-1, 4)


func _handle_zoom() -> void:
	if Input.is_action_pressed("zoom_in"):
		apply_zoom(-1)
	if Input.is_action_pressed("zoom_out"):
		apply_zoom()

func apply_zoom(direction : int = 1, factor : int = 1) -> void:
	var new_zoom := zoom
	
	new_zoom += Vector2.ONE * zoom_speed * sign(direction) * factor
	
	new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
	new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)
	
	zoom = new_zoom
