# 1 - Head e Body Seguir Mouse
# 2 - Fazer Zoom in out
extends SpringArm3D

@onready var camera: Camera3D = self.get_node("Camera")

@onready var speed: float = 0.2

func _ready() -> void: 
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta: float) -> void:
	_visible_mouse()
	_camera_mode()
	_rot_cam()
	
func _rot_cam() -> void:
	var i = Input.get_action_strength("move_cam_r") - Input.get_action_strength("move_cam_l")
	if i != 0:
		self.transform.basis = Basis(Vector3.UP, -i * speed * get_process_delta_time()) * self.transform.basis
		print(1)
	
func _visible_mouse() -> void:
	if (Input.is_action_pressed("ui_down")):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif (Input.is_action_just_pressed("ui_up")):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _camera_mode() -> void:
	if (Input.is_action_pressed("aim")):
		camera.keep_aspect = Camera3D.KEEP_WIDTH
	else:
		camera.keep_aspect = Camera3D.KEEP_HEIGHT
