extends Node3D

# Childs
@onready var ray: RayCast3D = self.get_node("RayCast3D")
@onready var area: Area3D = self.get_node("Area")
@onready var detection_entered: Area3D = self.get_node("Area/DetectionEntered")
@onready var detection_exited: Area3D = self.get_node("Area/DetectionExited")

@export_category("Smooths")
@export var aim_colliding: float = 3.5
@export var sync_with_cam: float = 5.0
@export var target_aim: float = 4.0

@export_category("Configs")
@export var locked_aim: bool = false

var area_position: Vector3

var can_target: bool
var target_detected: bool 

func _ready() -> void:
	detection_entered.area_entered.connect(
		Callable(
			_on_detection_entered_in
		))
	detection_entered.area_exited.connect(
		Callable(
			_on_detection_entered_out
		))
	
	detection_exited.area_entered.connect(
		Callable(
			_detection_exited_in
		))
	detection_exited.area_exited.connect(
		Callable(
			_detection_exited_out
		))

func look_aim(target: Array,spring: SpringArm3D, delta: float) -> void:
	var calc = target[1].rotation.y + spring.rotation.y
	
	var look = lerp_angle(
		self.rotation.y,
		calc,
		sync_with_cam * get_process_delta_time())
	
	self.rotation = Vector3(target[0].rotation.x , look, 0.0)
	if (!target_detected):
		if (ray.is_colliding()):
			var dir = lerp(
				area.global_transform.origin,
				ray.get_collision_point(),
				aim_colliding * delta
				)
			area.global_transform.origin = dir
		var center = lerp(
				detection_entered.global_transform.origin,
				detection_exited.global_transform.origin,
				20 * delta
				)
		detection_entered.global_transform.origin = center
		detection_entered.top_level = false
	else:
		if (area_position.length() != 0 && can_target):
			var look_to = lerp(
				detection_entered.global_transform.origin,
				area_position,
				target_aim * delta
				)
			detection_entered.global_transform.origin = look_to
			detection_entered.top_level = locked_aim
			print(error_string(OK))
		else:
			print(error_string(ERR_BUG))
			target_detected = false

func _on_detection_entered_in(area: Area3D) -> void:
	if (area.is_in_group("Targets")):
		area_position = area.global_position
		target_detected = true
func _on_detection_entered_out(area: Area3D) -> void:
	if (area.is_in_group("Targets")):
		area_position = Vector3.ZERO
		target_detected = false

func _detection_exited_in(area: Area3D) -> void:
	if (area.is_in_group("Aim")):
		can_target = true
func _detection_exited_out(area: Area3D) -> void:
	if (area.is_in_group("Aim")):
		can_target = false
