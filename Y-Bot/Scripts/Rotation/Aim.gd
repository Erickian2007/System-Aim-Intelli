extends Node3D

# Childs
@onready var ray: RayCast3D = self.get_node("RayCast3D")
@onready var area: Area3D = self.get_node("Area")

@export_category("Smooths")
@export var aim_colliding: float = 3.5
@export var sync_with_cam: float = 5.0

func look_aim(target: Array,spring: SpringArm3D, acel_x: float, acel_y: float) -> void:
	var look = lerp_angle(self.rotation.y, target[1].rotation.y + spring.rotation.y, sync_with_cam * get_process_delta_time())
	
	self.rotation = Vector3(target[0].rotation.x , look, 0.0)
	if (ray.is_colliding()):
		var dir = lerp(area.global_transform.origin, ray.get_collision_point(), aim_colliding * get_process_delta_time())
		area.global_transform.origin = dir
