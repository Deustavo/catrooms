extends Node
## Estado global do jogo: progressão de níveis e RNG compartilhado.
## Não conhece cenas concretas — apenas reage e emite sinais via Events.

const BASE_ROOM_SIZE := 6
const SIZE_GROWTH_PER_LEVEL := 2
const MAX_ROOM_SIZE := 21
const MAX_LEVEL := 10
const DEFAULT_MOUSE_SENSITIVITY := 0.004

var current_level := 1
var rng := RandomNumberGenerator.new()
var mouse_sensitivity := DEFAULT_MOUSE_SENSITIVITY


func _ready() -> void:
	rng.randomize()
	Events.exit_reached.connect(_on_exit_reached)


func start_game() -> void:
	current_level = 1
	Events.level_started.emit(current_level)


## Lado da sala (quadrada) cresce com o nível, até um teto.
func room_size_for_level(level: int) -> int:
	return mini(BASE_ROOM_SIZE + (level - 1) * SIZE_GROWTH_PER_LEVEL, MAX_ROOM_SIZE)


func _on_exit_reached() -> void:
	if current_level >= MAX_LEVEL:
		Events.game_completed.emit()
		return
	current_level += 1
	Events.level_started.emit(current_level)


func set_mouse_sensitivity(value: float) -> void:
	mouse_sensitivity = value
	Events.mouse_sensitivity_changed.emit(value)
