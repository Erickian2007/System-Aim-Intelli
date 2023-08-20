extends Node3D

func rot(skeleton: Skeleton3D, target: Array, model: Node3D = null) -> void:
	# 1 - bone head
	var bone_head_index = skeleton.find_bone("mixamorig_Head")
	var bone_head_quat = skeleton.get_bone_pose_rotation(bone_head_index)
	# 2 - bone body
	var bone_body_index = skeleton.find_bone("mixamorig_Spine")
	var _bone_body_quat = skeleton.get_bone_pose_rotation(bone_body_index)
	self.rotate_object_local(Vector3.UP, self.rotation.y) 
	# 1 - head e body seguindo mouse
	if (Input.is_action_pressed("aim")):
		# head_node look mouse direction(head_dir)
		_rot_bone(skeleton, target, bone_head_index, bone_head_quat)
		_rot_model(model, target)
	else:
		# head_node return center
		_rot_head_body_return(bone_head_index, bone_head_quat)

func _rot_bone(skeleton: Skeleton3D, target: Array, bone_index: int, bone_quat: Quaternion) -> void:
	var quat_mouse_pos = (
		Vector3(
			target[0].rotation.x,
			target[1].rotation.y,
			0.0
	))
	var quat = bone_quat.from_euler(quat_mouse_pos)
	# 1 - olha para a direção do mouse
	skeleton.set_bone_pose_rotation(bone_index, quat)

func _rot_head_body_return(_bone_index: int, _bone_quat: Quaternion) -> void:		
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
	self.transform.basis = Basis()

func _rot_model(model: Node3D, target: Array) -> void:
	model.rotation.y = (
		lerp_angle(
			model.rotation.y,
			target[1].rotation.y,
			0.2
			))
