class_name EnemySpawner
extends Node3D
## Popula a sala com inimigos a cada nível. A partir do FIRST_ENEMY_LEVEL
## surge 1 poeira, dobrando a quantidade a cada nível seguinte. Posições são
## sorteadas aleatoriamente entre as células da sala, evitando a saída do
## jogador e uma área segura ao redor do spawn.

const POEIRA_SCENE := preload("res://src/enemies/poeira.tscn")
const FIRST_ENEMY_LEVEL := 2

## Raio (em células) ao redor do spawn do jogador onde nenhum inimigo pode
## aparecer, para evitar que ele surja colado nele.
@export var spawn_safe_radius := 2

var _spawn_attempts_limit := 50


func spawn_for_level(level: int, size: int, room_builder: RoomBuilder, target: Node3D) -> void:
	_clear()
	if level < FIRST_ENEMY_LEVEL:
		return

	var count := 1 << (level - FIRST_ENEMY_LEVEL)
	var excluded_cells := [Vector2i(size - 1, size - 1)]
	var chase_range := (size * room_builder.cell_size) / 4.0

	for i in count:
		var cell := _random_cell(size, excluded_cells)
		var enemy: Poeira = POEIRA_SCENE.instantiate()
		add_child(enemy)
		enemy.global_position = room_builder.get_cell_center(cell) + Vector3.UP * 0.2
		enemy.target = target
		enemy.chase_range = chase_range


func _clear() -> void:
	for child in get_children():
		child.free()


func _random_cell(size: int, excluded_cells: Array) -> Vector2i:
	var cell := Vector2i.ZERO
	for attempt in _spawn_attempts_limit:
		cell = Vector2i(
			GameManager.rng.randi_range(0, size - 1), GameManager.rng.randi_range(0, size - 1)
		)
		if not _is_near_spawn(cell) and not excluded_cells.has(cell):
			return cell
	return cell


## Distância de Chebyshev até o spawn do jogador (canto (0,0)).
func _is_near_spawn(cell: Vector2i) -> bool:
	return maxi(cell.x, cell.y) <= spawn_safe_radius
