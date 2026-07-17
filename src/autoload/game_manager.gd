extends Node
## Estado global do jogo: progressão de níveis e RNG compartilhado.
## Não conhece cenas concretas — apenas reage e emite sinais via Events.

const BASE_MAZE_SIZE := 6
const SIZE_GROWTH_PER_LEVEL := 2
const MAX_MAZE_SIZE := 21
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


## Tamanho do labirinto cresce com o nível, até um teto.
func maze_size_for_level(level: int) -> Vector2i:
	var n := mini(BASE_MAZE_SIZE + (level - 1) * SIZE_GROWTH_PER_LEVEL, MAX_MAZE_SIZE)
	return Vector2i(n, n)


func _on_exit_reached() -> void:
	current_level += 1
	Events.level_started.emit(current_level)


func set_mouse_sensitivity(value: float) -> void:
	mouse_sensitivity = value
	Events.mouse_sensitivity_changed.emit(value)
