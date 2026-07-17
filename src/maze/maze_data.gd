class_name MazeData
extends RefCounted
## Dados e geração de labirinto em grade (recursive backtracker iterativo).
## Lógica pura, sem dependência da árvore de cena — testável e reutilizável.
## O RNG é injetado, permitindo níveis reproduzíveis por seed.

enum Dir { NORTH, EAST, SOUTH, WEST }

const OFFSETS := {
	Dir.NORTH: Vector2i(0, -1),
	Dir.EAST: Vector2i(1, 0),
	Dir.SOUTH: Vector2i(0, 1),
	Dir.WEST: Vector2i(-1, 0),
}
const OPPOSITE := {
	Dir.NORTH: Dir.SOUTH,
	Dir.EAST: Dir.WEST,
	Dir.SOUTH: Dir.NORTH,
	Dir.WEST: Dir.EAST,
}

var width: int
var height: int

# Bitmask por célula: bit (1 << Dir) ligado = parede intacta naquela direção.
var _walls: PackedInt32Array


func _init(p_width: int, p_height: int) -> void:
	assert(p_width > 0 and p_height > 0)
	width = p_width
	height = p_height
	_walls.resize(width * height)
	_walls.fill(0b1111)


## Escava passagens a partir de `start` até visitar todas as células.
func generate(rng: RandomNumberGenerator, start := Vector2i.ZERO) -> void:
	var visited: PackedByteArray
	visited.resize(width * height)
	var stack: Array[Vector2i] = [start]
	visited[_index(start)] = 1

	while not stack.is_empty():
		var cell: Vector2i = stack.back()
		var options := _unvisited_neighbors(cell, visited)
		if options.is_empty():
			stack.pop_back()
			continue
		var dir: int = options[rng.randi_range(0, options.size() - 1)]
		var next: Vector2i = cell + OFFSETS[dir]
		_carve(cell, dir)
		visited[_index(next)] = 1
		stack.push_back(next)


func has_wall(cell: Vector2i, dir: Dir) -> bool:
	return _walls[_index(cell)] & (1 << dir) != 0


func is_inside(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < width and cell.y >= 0 and cell.y < height


func _unvisited_neighbors(cell: Vector2i, visited: PackedByteArray) -> Array[int]:
	var result: Array[int] = []
	for dir: int in OFFSETS:
		var next: Vector2i = cell + OFFSETS[dir]
		if is_inside(next) and visited[_index(next)] == 0:
			result.append(dir)
	return result


## Remove a parede entre `cell` e a célula vizinha na direção `dir` (dos dois lados).
func _carve(cell: Vector2i, dir: int) -> void:
	var next: Vector2i = cell + OFFSETS[dir]
	_walls[_index(cell)] &= ~(1 << dir)
	_walls[_index(next)] &= ~(1 << OPPOSITE[dir])


func _index(cell: Vector2i) -> int:
	return cell.y * width + cell.x
