# 1 - Head e Body Seguir Mouse
# 2 - Fazer Zoom in out
extends SpringArm3D

@onready var player: CharacterBody3D = $".."

@onready var look_to: Node3D = player.get_node("LookTo")

@onready var model: Node3D = player.get_node("Model")
@onready var skeleton: Skeleton3D = player.get_node("Model/RootNode/Skeleton3D")

@onready var camera: Camera3D = self.get_node("Camera")

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

		look_to.get_node("Y/X").rotate_y(-sensi.x)
		look_to.get_node("Y/X").rotation.y = (
			clamp(
			look_to.get_node("Y/X").rotation.y,
			deg_to_rad(-90),
			deg_to_rad(90)
		))
		print(look_to.get_node("Y/X").rotation_degrees.y)
	
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta: float) -> void:
	if (Input.is_action_pressed("ui_down")):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif (Input.is_action_just_pressed("ui_up")):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	look_to.rotate_object_local(Vector3.UP, self.rotation.y) 
	
	# 1 - bone head
	var bone_index = skeleton.find_bone("mixamorig_Head")
	var bone_quat = skeleton.get_bone_pose_rotation(bone_index)

	# 1 - head e body seguindo mouse
	if (Input.is_action_pressed("aim")):
		# head_node look mouse direction(head_dir)
		camera.keep_aspect = camera.KEEP_WIDTH
		camera.position.x = 0.6
		# 1- model olha para a direção do mouse
		model.rotation.y = (
			lerp_angle(
				model.rotation.y,
				self.rotation.y + deg_to_rad(180),
				0.2
				))
		var quat_mouse_pos = (
			Vector3(
				-self.rotation.x,
				look_to.get_node("Y/X").rotation.y,
				0.0
			))
		var quat = bone_quat.from_euler(quat_mouse_pos)
		# 1 - head olha para a direção do mouse
		skeleton.set_bone_pose_rotation(bone_index, quat)

	else:
		# head_node return center
		camera.keep_aspect = camera.KEEP_HEIGHT
		camera.position.x = 0.0
		
		var linear_return = lerp(bone_quat.get_euler().y, 0.0, 0.3)

		var quat_mouse_pos = (
			Vector3(
				0.0,
				linear_return,
				0.0
			))
		var quat = bone_quat.from_euler(quat_mouse_pos)
		skeleton.set_bone_pose_rotation(bone_index, quat)
		look_to.get_node("Y/X").transform.basis = Basis()
