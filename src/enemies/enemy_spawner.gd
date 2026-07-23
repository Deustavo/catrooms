class_name EnemySpawner
extends Node3D
## Popula a sala com inimigos a cada nível. A partir do FIRST_ENEMY_LEVEL
## surge 1 poeira, dobrando a quantidade a cada nível seguinte. Posições são
## sorteadas aleatoriamente entre as células da sala, evitando o spawn e a
## saída do jogador.

const POEIRA_SCENE := preload("res://src/enemies/poeira.tscn")
const FIRST_ENEMY_LEVEL := 2

var _spawn_attempts_limit := 50


func spawn_for_level(level: int, size: int, room_builder: RoomBuilder, target: Node3D) -> void:
	_clear()
	if level < FIRST_ENEMY_LEVEL:
		return

	var count := 1 << (level - FIRST_ENEMY_LEVEL)
	var excluded_cells := [Vector2i.ZERO, Vector2i(size - 1, size - 1)]

	for i in count:
		var cell := _random_cell(size, excluded_cells)
		var enemy: Poeira = POEIRA_SCENE.instantiate()
		add_child(enemy)
		enemy.global_position = room_builder.get_cell_center(cell) + Vector3.UP * 0.2
		enemy.target = target


func _clear() -> void:
	for child in get_children():
		child.free()


func _random_cell(size: int, excluded_cells: Array) -> Vector2i:
	var cell := Vector2i.ZERO
	for attempt in _spawn_attempts_limit:
		cell = Vector2i(
			GameManager.rng.randi_range(0, size - 1), GameManager.rng.randi_range(0, size - 1)
		)
		if not excluded_cells.has(cell):
			return cell
	return cell
