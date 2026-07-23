class_name RoomBuilder
extends Node3D
## Constrói uma sala quadrada aberta: chão, teto, as 4 paredes externas e o
## gatilho de saída. Não há paredes internas — a sala é um espaço único.

@export var cell_size := 3.0
@export var wall_height := 3.0
@export var wall_thickness := 0.3
@export var wall_material: Material
@export var floor_material: Material
@export var ceiling_material: Material

var _size := 0
var _exit_consumed := false


## `size` é o lado da sala em células (a sala é sempre quadrada).
func build(size: int) -> void:
	assert(size > 0)
	_size = size
	_exit_consumed = false
	_clear()
	_prepare_shared_resources()
	_build_floor_and_ceiling()
	_build_walls()
	_build_exit(Vector2i(size - 1, size - 1))


func get_cell_center(cell: Vector2i) -> Vector3:
	return Vector3((cell.x + 0.5) * cell_size, 0.0, (cell.y + 0.5) * cell_size)


func get_spawn_position() -> Vector3:
	return get_cell_center(Vector2i.ZERO) + Vector3.UP * 0.2


func _clear() -> void:
	for child in get_children():
		child.free()


func _prepare_shared_resources() -> void:
	if wall_material == null:
		wall_material = _make_material(Color(0.75, 0.7, 0.55))
	if floor_material == null:
		floor_material = _make_material(Color(0.45, 0.42, 0.3))
	if ceiling_material == null:
		ceiling_material = _make_material(Color(0.6, 0.57, 0.45))


func _build_floor_and_ceiling() -> void:
	var side := _size * cell_size
	var total := Vector3(side, 0.2, side)
	var center_xz := Vector3(total.x / 2.0, 0.0, total.z / 2.0)

	var floor_body := StaticBody3D.new()
	floor_body.name = "Floor"
	floor_body.position = center_xz + Vector3.DOWN * (total.y / 2.0)
	_add_box(floor_body, total, floor_material)
	add_child(floor_body)

	var ceiling := MeshInstance3D.new()
	ceiling.name = "Ceiling"
	ceiling.position = center_xz + Vector3.UP * (wall_height + total.y / 2.0)
	var mesh := BoxMesh.new()
	mesh.size = total
	mesh.material = ceiling_material
	ceiling.mesh = mesh
	add_child(ceiling)


## Constrói apenas o perímetro da sala — nenhuma parede interna.
func _build_walls() -> void:
	var walls := Node3D.new()
	walls.name = "Walls"
	add_child(walls)

	var side := _size * cell_size
	var half_side := side / 2.0
	var length := side + wall_thickness

	var h_mesh := BoxMesh.new()
	h_mesh.size = Vector3(length, wall_height, wall_thickness)
	h_mesh.material = wall_material
	var h_shape := BoxShape3D.new()
	h_shape.size = h_mesh.size

	var v_mesh := BoxMesh.new()
	v_mesh.size = Vector3(wall_thickness, wall_height, length)
	v_mesh.material = wall_material
	var v_shape := BoxShape3D.new()
	v_shape.size = v_mesh.size

	_spawn_wall(walls, Vector3(half_side, wall_height / 2.0, 0.0), h_mesh, h_shape)
	_spawn_wall(walls, Vector3(half_side, wall_height / 2.0, side), h_mesh, h_shape)
	_spawn_wall(walls, Vector3(0.0, wall_height / 2.0, half_side), v_mesh, v_shape)
	_spawn_wall(walls, Vector3(side, wall_height / 2.0, half_side), v_mesh, v_shape)


func _spawn_wall(parent: Node3D, wall_position: Vector3, mesh: Mesh, shape: Shape3D) -> void:
	var body := StaticBody3D.new()
	body.position = wall_position

	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = mesh
	body.add_child(mesh_instance)

	var collision := CollisionShape3D.new()
	collision.shape = shape
	body.add_child(collision)

	parent.add_child(body)


func _build_exit(cell: Vector2i) -> void:
	var center := get_cell_center(cell)

	var area := Area3D.new()
	area.name = "Exit"
	area.position = center + Vector3.UP * (wall_height / 2.0)
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(cell_size * 0.6, wall_height, cell_size * 0.6)
	collision.shape = shape
	area.add_child(collision)
	area.body_entered.connect(_on_exit_body_entered)
	add_child(area)

	# Marcador visual: pilar emissivo + luz para guiar o jogador.
	var marker := MeshInstance3D.new()
	marker.name = "ExitMarker"
	marker.position = center + Vector3.UP * (wall_height / 2.0)
	var mesh := BoxMesh.new()
	mesh.size = Vector3(0.4, wall_height, 0.4)
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.2, 1.0, 0.4)
	mat.emission_enabled = true
	mat.emission = Color(0.2, 1.0, 0.4)
	mat.emission_energy_multiplier = 2.0
	mesh.material = mat
	marker.mesh = mesh
	add_child(marker)

	var light := OmniLight3D.new()
	light.position = center + Vector3.UP * (wall_height * 0.6)
	light.light_color = Color(0.3, 1.0, 0.5)
	light.omni_range = cell_size * 2.0
	add_child(light)


func _on_exit_body_entered(body: Node3D) -> void:
	if _exit_consumed or not (body is Player):
		return
	_exit_consumed = true
	Events.exit_reached.emit()


func _add_box(body: StaticBody3D, size: Vector3, material: Material) -> void:
	var mesh_instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh.material = material
	mesh_instance.mesh = mesh
	body.add_child(mesh_instance)

	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collision.shape = shape
	body.add_child(collision)


func _make_material(color: Color) -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.9
	return mat
