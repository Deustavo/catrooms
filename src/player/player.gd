class_name Player
extends CharacterBody3D
## Controlador de primeira pessoa: movimento WASD, sprint, pulo e mouse look.
## O corpo gira em Y (yaw); a cabeça gira em X (pitch).

@export_group("Movimento")
@export var walk_speed := 4.0
@export var sprint_speed := 7.0
## Aceleração horizontal em m/s².
@export var acceleration := 40.0
@export var jump_velocity := 4.5

@export_group("Câmera")
@export var mouse_sensitivity := 0.004
@export var pitch_limit_deg := 89.0

@onready var _head: Node3D = $Head


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mouse_sensitivity = GameManager.mouse_sensitivity
	Events.mouse_sensitivity_changed.connect(_on_mouse_sensitivity_changed)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_apply_mouse_look(event.relative)
	elif event is InputEventMouseButton and event.pressed \
			and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
	var speed := sprint_speed if Input.is_action_pressed("sprint") else walk_speed
	var target := direction * speed

	velocity.x = move_toward(velocity.x, target.x, acceleration * delta)
	velocity.z = move_toward(velocity.z, target.z, acceleration * delta)

	move_and_slide()


## Reposiciona o jogador zerando a inércia (usado na troca de nível).
func teleport_to(target_position: Vector3) -> void:
	global_position = target_position
	velocity = Vector3.ZERO


func _on_mouse_sensitivity_changed(value: float) -> void:
	mouse_sensitivity = value


func _apply_mouse_look(relative: Vector2) -> void:
	rotate_y(-relative.x * mouse_sensitivity)
	_head.rotate_x(-relative.y * mouse_sensitivity)
	var limit := deg_to_rad(pitch_limit_deg)
	_head.rotation.x = clampf(_head.rotation.x, -limit, limit)
