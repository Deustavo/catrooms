class_name Poeira
extends CharacterBody3D
## Inimigo básico: um quadro 2D (billboard) sempre voltado para a câmera.
## Persegue o alvo quando ele está dentro de chase_range; fora desse
## alcance, vaga em direções aleatórias. Exibe uma borda laranja no sprite
## enquanto estiver perseguindo.

@export var speed := 2.2
@export var wander_speed := 0.8
@export var wander_direction_interval := 2.0

var target: Node3D
var chase_range := INF

var _wander_direction := Vector3.ZERO
var _wander_timer := 0.0
var _is_chasing := false

@onready var _touch_area: Area3D = $TouchArea
@onready var _mesh_material: ShaderMaterial = $MeshInstance3D.get_surface_override_material(0)


func _ready() -> void:
	_touch_area.body_entered.connect(_on_touch_area_body_entered)
	_pick_new_wander_direction()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction := _compute_direction(delta)
	var current_speed := speed if _is_chasing else wander_speed
	velocity.x = direction.x * current_speed
	velocity.z = direction.z * current_speed

	move_and_slide()
	_update_chase_outline()


func _compute_direction(delta: float) -> Vector3:
	_is_chasing = false
	if target != null:
		var to_target := target.global_position - global_position
		to_target.y = 0.0
		var distance := to_target.length()
		if distance <= chase_range:
			_is_chasing = true
			return to_target.normalized() if distance > 0.1 else Vector3.ZERO

	return _wander(delta)


func _update_chase_outline() -> void:
	_mesh_material.set_shader_parameter("chasing", _is_chasing)


func _wander(delta: float) -> Vector3:
	_wander_timer -= delta
	if _wander_timer <= 0.0:
		_pick_new_wander_direction()
	return _wander_direction


func _pick_new_wander_direction() -> void:
	_wander_timer = wander_direction_interval
	var angle := GameManager.rng.randf_range(0.0, TAU)
	_wander_direction = Vector3(cos(angle), 0.0, sin(angle))


func _on_touch_area_body_entered(body: Node3D) -> void:
	if body is Player:
		Events.player_caught.emit()
