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
var _game_over := false


func _ready() -> void:
	rng.randomize()
	Events.exit_reached.connect(_on_exit_reached)
	Events.player_caught.connect(_on_player_caught)


func start_game() -> void:
	current_level = 1
	_game_over = false
	Events.level_started.emit(current_level)


## Recomeça o nível atual (usado ao morrer), sem voltar ao nível 1.
func restart_level() -> void:
	_game_over = false
	Events.level_started.emit(current_level)


## Lado da sala (quadrada) cresce com o nível, até um teto.
func room_size_for_level(level: int) -> int:
	return mini(BASE_ROOM_SIZE + (level - 1) * SIZE_GROWTH_PER_LEVEL, MAX_ROOM_SIZE)


func _on_exit_reached() -> void:
	if _game_over:
		return
	if current_level >= MAX_LEVEL:
		Events.game_completed.emit()
		return
	current_level += 1
	Events.level_started.emit(current_level)


func _on_player_caught() -> void:
	if _game_over:
		return
	_game_over = true
	Events.game_over.emit()


func set_mouse_sensitivity(value: float) -> void:
	mouse_sensitivity = value
	Events.mouse_sensitivity_changed.emit(value)
