extends Node2D
class_name World

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var tile_map_layer_2: TileMapLayer = $TileMapLayer2

const alive : Vector2i = Vector2i(0, 0)

static var _instance : World

var current_state : TileMapLayer
var next_state : TileMapLayer
var total_cells = []
var paused : bool = false
var frame_delay_ms : int = 50
var last_frame := -100

var camera_mode_move := false
var camera_mode_zoom := false
var is_mobile_player := false

static func get_instance() -> World:
	return _instance


func _ready() -> void:
	_instance = self


func _process(delta: float) -> void:
	if paused:
		return
	if Time.get_ticks_msec() > last_frame + frame_delay_ms:
		last_frame = Time.get_ticks_msec()
	else:
		return
	swap_tilemaps()
	total_cells = []
	for c in current_state.get_used_cells():
		add(c)
		add(c + Vector2i.UP)
		add(c + Vector2i.DOWN)
		add(c + Vector2i.LEFT)
		add(c + Vector2i.RIGHT)
		add(c + Vector2i.UP + Vector2i.LEFT)
		add(c + Vector2i.UP + Vector2i.RIGHT)
		add(c + Vector2i.DOWN + Vector2i.LEFT)
		add(c + Vector2i.DOWN + Vector2i.RIGHT)
	for c : Vector2i in total_cells:
		var n := neighbours_count(c)
		if is_alive(c):
			if n == 2 or n == 3:
				next_state.set_cell(c, 0, alive)
		else:
			if n == 3:
				next_state.set_cell(c, 0, alive)

func neighbours_count(c : Vector2i) -> int:
	var count : int = 0
	if is_alive(c + Vector2i.UP):
		count += 1
	if is_alive(c + Vector2i.DOWN):
		count += 1
	if is_alive(c + Vector2i.LEFT):
		count += 1
	if is_alive(c + Vector2i.RIGHT):
		count += 1
	if is_alive(c + Vector2i.UP + Vector2i.LEFT):
		count += 1
	if is_alive(c + Vector2i.UP + Vector2i.RIGHT):
		count += 1
	if is_alive(c + Vector2i.DOWN + Vector2i.LEFT):
		count += 1
	if is_alive(c + Vector2i.DOWN + Vector2i.RIGHT):
		count += 1
	return count

func add(c : Vector2i) -> void:
	if !total_cells.has(c):
		total_cells.push_front(c)

func is_alive(c : Vector2i) -> bool:
	return current_state.get_cell_source_id(c) > -1

func set_alive(c : Vector2i, is_alive : bool = true) -> void:
	if is_alive:
		next_state.set_cell(c, 0, alive)
	else:
		next_state.set_cell(c)

func swap_tilemaps():
	if current_state == null or current_state == tile_map_layer_2:
		current_state = tile_map_layer
		next_state =  tile_map_layer_2
	else:
		current_state = tile_map_layer_2
		next_state =  tile_map_layer
	current_state.visible = false
	next_state.visible = true
	next_state.clear()

func clear_all() -> void:
	current_state.clear()
	next_state.clear()

func add_delay(delay : int) -> void:
	if frame_delay_ms + delay >= 0:
		frame_delay_ms += delay
	else:
		frame_delay_ms = 0
	
	
