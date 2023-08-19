# 1 - Head e Body Seguir Mouse
# 2 - Fazer Z

extends SpringArm3D

@onready var player = $".."
@onready var head = player.get_node("Mesh/Godot_Chan_Stealth_Shooter/Godot_Chan_Stealth/Skeleton3D/Head")
@onready var head_dir = player.get_node("HeadDir")
@onready var body_rot_area = player.get_node("BodyRot")

@onready var camera = self.get_node("Camera")

const sensi_x = 0.002
const sensi_y = 0.001

var limit_mouse_y_max = 90.0
var limit_mouse_y_min = -90.0

var limit_head_y_max = 26.0
var limit_head_y_min = -17.0

var weight_head_look_mouse = 0.3

var weight_head_return_center_x = 3.0
var weight_head_return_center_y = 0.1

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
	# limit axys y of spring arm
		self.rotation_degrees.x = (
			clamp(self.rotation_degrees.x,
			limit_mouse_y_min,
			limit_mouse_y_max
			))

		# 1 
		if (Input.is_action_pressed("aim")):
		# head look mouse direction(head_dir)
			head.rotation_degrees.y = (
				lerp(
					head.rotation_degrees.y,
					head_dir.rotation_degrees.y,
					weight_head_look_mouse
				))
		# limit head deslocation y
			head.rotation.x += sensi.y
			head.rotation_degrees.x = (
				clamp(head.rotation_degrees.x,
					limit_head_y_min,
					limit_head_y_max
				))
			print(head.rotation.y)
			
func _process(delta: float) -> void:
	# 1
	if (!Input.is_action_pressed("aim")):
	# return center head
		head.rotation.x = (
				lerp_angle(head.rotation.x,
					0.0,
					1 * delta
				))
		head.rotation.y = (
				lerp_angle(head.rotation.y,
					0.0,
					3 * delta
				))
	
	# head_dir getting rotation of spring_arm
	head_dir.global_rotation_degrees.y = self.global_rotation_degrees.y + 180
	
	
	# 2
	# zoom in out
	if (Input.is_action_pressed("aim")):
		camera.keep_aspect = camera.KEEP_WIDTH
		camera.position.x = 0.6
	else:
		camera.keep_aspect = camera.KEEP_HEIGHT
		camera.position.x = 0.0
