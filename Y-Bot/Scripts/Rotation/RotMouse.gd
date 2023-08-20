extends Node3D

# Parents
@onready var player: CharacterBody3D = $".."
@onready var model: Node3D = player.get_node("Model")
@onready var skeleton: Skeleton3D = player.get_node("Model/RootNode/Skeleton3D")

@onready var spring_arm: SpringArm3D = player.get_node("SpringArm")
@onready var aim_node: Node3D = player.get_node("Aim")
@onready var look_to: Node3D = player.get_node("LookTo")

# Childs
@onready var x: Node3D = self.get_node("Y/X")
@onready var y: Node3D = self.get_node("Y")
@onready var ventor = [x,y]

const sensi_speed_x = 0.2
const sensi_speed_y = 0.1

@export_category("Limits")
@export var limit_mouse_y_max: float = 90.0
@export var limit_mouse_y_min: float = -90.0


func _input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion):
	# camera getting position relative of mouse
		var sensi = Vector2(
			(deg_to_rad(event.relative.x) * sensi_speed_x),
			(deg_to_rad(event.relative.y) * sensi_speed_y))
		
		y.rotate_object_local(Vector3.UP, -sensi.x)
		x.rotate_object_local(Vector3.RIGHT,sensi.y)
		
		x.rotation_degrees.x = (
			clamp(
				x.rotation_degrees.x,
				limit_mouse_y_min,
				limit_mouse_y_max
			))
			
		aim_node.look_aim(ventor, spring_arm,sensi.x, sensi.y)
func _process(delta: float) -> void:
	look_to.rot(skeleton, ventor, model)
