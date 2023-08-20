# 1 - Head e Body Seguir Mouse
# 2 - Fazer Zoom in out

extends SpringArm3D

@onready var player: CharacterBody3D = $".."
@onready var model: Node3D = player.get_node("Mesh")
@onready var bone_node: Skeleton3D = player.get_node("Mesh/Godot_Chan_Stealth_Shooter/Godot_Chan_Stealth/Skeleton3D")
@onready var head_node: Node3D = player.get_node("Mesh/Godot_Chan_Stealth_Shooter/Godot_Chan_Stealth/Skeleton3D/Head")
@onready var body_model: MeshInstance3D = player.get_node("Mesh/Godot_Chan_Stealth_Shooter/Godot_Chan_Stealth/Skeleton3D/armor")
@onready var head_dir: RayCast3D = player.get_node("HeadDir")
@onready var body_rot: Area3D = player.get_node("BodyRot")

@onready var camera: Camera3D = self.get_node("Camera")

@export var weight: float = 1.0
@export var weight_return = 1.0

const sensi_x = 0.002
const sensi_y = 0.001

var limit_mouse_y_max = 90.0
var limit_mouse_y_min = -90.0

var limit_head_y_max = 26.0
var limit_head_y_min = -17.0

var weight_head_look_mouse = 0.3

var weight_head_return_center_x = 3.0
var weight_head_return_center_y = 0.1

var can_rot_body: bool

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion):
	# camera getting position relative of mouse
		var sensi = Vector2(
			(event.relative.x * sensi_x),
			(event.relative.y * sensi_y))
		
		self.rotation.y -= sensi.x
		self.rotation.x -= sensi.y

		head_node.rotation_degrees.y = wrapf(head_node.rotation_degrees.y, -360.0, 360)
	# limit axys y of spring arm
		self.rotation_degrees.x = (
			clamp(self.rotation_degrees.x,
			limit_mouse_y_min,
			limit_mouse_y_max
			))
		head_dir.rotation.y = self.rotation.y
func _process(delta: float) -> void:
	# 1 - head e body seguindo mouse
	if (Input.is_action_pressed("aim")):
		# head_node look mouse direction(head_dir)
		camera.keep_aspect = camera.KEEP_WIDTH
		camera.position.x = 0.6
		_rot_spine(delta)
	else:
		# head_node return center
		camera.keep_aspect = camera.KEEP_HEIGHT
		camera.position.x = 0.0	
func _rot_spine(_delta: float) -> void:
	var min_rot = deg_to_rad(-90) + deg_to_rad(180)
	var max_rot = deg_to_rad(90) + deg_to_rad(180)
	var bone_index = bone_node.find_bone("spine_02")
	var bone_quat = bone_node.get_bone_pose_rotation(bone_index)
	var y_clamp = clamp(self.rotation.y, min_rot, max_rot)
	var ventor = Vector3(-self.rotation.x, y_clamp + deg_to_rad(180), self.rotation.z)
	print(deg_to_rad(ventor.y))
	var quat = bone_quat.from_euler(ventor)
	bone_node.set_bone_pose_rotation(bone_index, quat)