extends Node3D

@onready var player: CharacterBody3D = $".."
@onready var spring_arm: SpringArm3D = player.get_node("SpringArm")
@onready var ray: RayCast3D = self.get_node("RayCast3D")
@onready var sprite: Sprite3D = self.get_node("Sprite3D")

@export_category("Smooths")
@export var aim_colliding: float = 3.5
@export var aim_noColliding: float = 0.3

const sensi_x = 0.2
const sensi_y = 0.1

var limit_mouse_y_max = 90.0
var limit_mouse_y_min = -90.0

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion):
	# camera getting position relative of mouse
		var sensi = Vector2(
			(deg_to_rad(event.relative.x) * sensi_x),
			(deg_to_rad(event.relative.y) * sensi_y))
		
		self.rotation.y -= sensi.x
		self.rotation.x -= sensi.y
		self.rotation_degrees.x = (
			clamp(self.rotation_degrees.x,
			limit_mouse_y_min,
			limit_mouse_y_max
			))

		_look_aim(sensi.x, sensi.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _look_aim(acel_x, acel_y) -> void:
	if (ray.is_colliding()):
		var dir = lerp(sprite.transform.origin, ray.get_collision_point(), aim_colliding * get_process_delta_time())
		sprite.transform.origin = dir
		self.rotation.y = spring_arm.rotation.y + deg_to_rad(180)
		self.rotation.x = -spring_arm.rotation.x
	else:
		var look_y = lerp_angle(
			self.rotation.y,
			spring_arm.rotation.y + deg_to_rad(180) + acel_x,
			aim_noColliding
		)
		var look_x = lerp_angle(
			self.rotation.x,
			-spring_arm.rotation.x + acel_y,
			aim_noColliding
		)
		
		self.rotation.y = look_y
		self.rotation.x = look_x
