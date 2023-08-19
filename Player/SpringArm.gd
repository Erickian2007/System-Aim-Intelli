# 1 - Head e Body Seguir Mouse
# 2 - Fazer Zoom in out

extends SpringArm3D

@onready var player: CharacterBody3D = $".."
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
			
func _process(_delta: float) -> void:
	# 1 - head e body seguindo mouse
	if (Input.is_action_pressed("aim")):
		# head_node look mouse direction(head_dir)
		var look_y = 0.0
		var look_x = 0.0
		look_y = lerp_angle(look_y, self.rotation.y + deg_to_rad(180), weight)
		look_x = lerp_angle(look_x, -self.rotation.x, weight)
		head_node.get_node("y/x").transform.basis = Basis(Vector3(1,0,0), look_x)
		head_node.get_node("y").transform.basis = Basis(Vector3(0,1,0), look_y)
		# 2 - zoom in
		camera.keep_aspect = camera.KEEP_WIDTH
		camera.position.x = 0.6
	else:
		# head_node return center
		var center_x = lerp_angle(head_node.get_node("y/x").rotation.x, 0.0, weight_return)
		var center_y = lerp_angle(head_node.get_node("y").rotation.y, 0.0, weight_return)
		head_node.get_node("y/x").transform.basis = Basis(Vector3(1,0,0), center_x)
		head_node.get_node("y").transform.basis = Basis(Vector3(0,1,0), center_y)
		# 2 - zoom out
		camera.keep_aspect = camera.KEEP_HEIGHT
		camera.position.x = 0.0	
	body_rot.rotation.y = body_model.rotation.y
