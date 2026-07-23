class_name Poeira
extends CharacterBody3D
## Inimigo básico: um quadro 2D (billboard) que anda lentamente em direção
## ao alvo, sempre voltado para a câmera. Não ataca — apenas persegue.

@export var speed := 1.2

var target: Node3D

@onready var _touch_area: Area3D = $TouchArea


func _ready() -> void:
	_touch_area.body_entered.connect(_on_touch_area_body_entered)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if target != null:
		var to_target := target.global_position - global_position
		to_target.y = 0.0
		if to_target.length() > 0.1:
			var direction := to_target.normalized()
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = 0.0
			velocity.z = 0.0

	move_and_slide()


func _on_touch_area_body_entered(body: Node3D) -> void:
	if body is Player:
		Events.player_caught.emit()
