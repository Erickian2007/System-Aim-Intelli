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
	
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(_delta: float) -> void:
	# 1 - bone head
	var bone_head_index = skeleton.find_bone("mixamorig_Head")
	var bone_head_quat = skeleton.get_bone_pose_rotation(bone_head_index)
	# 2 - bone body
	var bone_body_index = skeleton.find_bone("mixamorig_Spine")
	var _bone_body_quat = skeleton.get_bone_pose_rotation(bone_body_index)
	look_to.rotate_object_local(Vector3.UP, self.rotation.y) 
	# 1 - head e body seguindo mouse
	if (Input.is_action_pressed("aim")):
		# head_node look mouse direction(head_dir)
		_rot(bone_head_index, bone_head_quat)
		_cameara_cfg(camera.KEEP_WIDTH, 0.6)
	else:
		# head_node return center
		_rot_head_body_return(bone_head_index, bone_head_quat)
		_cameara_cfg(camera.KEEP_HEIGHT, 0.0)
		
func _rot(bone_index, bone_quat) -> void:
	var quat_mouse_pos = (
		Vector3(
			-self.rotation.x,
			look_to.get_node("Y/X").rotation.y,
			0.0
	))
	var quat = bone_quat.from_euler(quat_mouse_pos)
	# 1 - olha para a direção do mouse
	skeleton.set_bone_pose_rotation(bone_index, quat)
	
func _rot_head_body_return(_bone_index, _bone_quat) -> void:		
#	var linear_head_return = lerp(bone_head_quat.get_euler().y, 0.0, 0.3)
#	var linear_body_return = lerp(bone_body_quat.get_euler(), Vector3.ZERO, 0.2)
#
#	var vec_head = Vector3(0.0, linear_head_return, 0.0)
#	var vec_body = Vector3(0.0, linear_body_return, 0.0)
#
#	var quat_head = bone_head_quat.from_euler(vec_head)
#	skeleton.set_bone_pose_rotation(bone_head_index, quat_head)
	
#	var quat_body = bone_body_quat.from_euler(vec_body)
#	skeleton.set_bone_pose_rotation(bone_body_index, quat_body)
#	
	look_to.get_node("Y/X").transform.basis = Basis()
			
func _rot_model() -> void:
	model.rotation.y = (
		lerp_angle(
			model.rotation.y,
			self.rotation.y + deg_to_rad(180),
			0.2
			))

func _visible_mouse() -> void:
	if (Input.is_action_pressed("ui_down")):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif (Input.is_action_just_pressed("ui_up")):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _cameara_cfg(mode: Camera3D.KeepAspect, pos_x: float) -> void:
	camera.keep_aspect = mode
	camera.position.x = pos_x
