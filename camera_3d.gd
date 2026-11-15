extends Camera3D

@export var target: Node3D
@export var base_offset: Vector3 = Vector3(0.0, 5.0, 8.0)
@export var max_mouse_offset: float = 3.0
@export var smooth_speed: float = 5.0 

func _process(delta: float) -> void:
	if not target:
		return

	var ground_plane := Plane(Vector3.UP, target.global_position.y)

	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var ray_origin: Vector3 = project_ray_origin(mouse_pos)
	var ray_dir: Vector3 = project_ray_normal(mouse_pos)
	var hit_point = ground_plane.intersects_ray(ray_origin, ray_dir)

	var mouse_offset := Vector3.ZERO
	if hit_point != null:
		mouse_offset = (hit_point - target.global_position).limit_length(max_mouse_offset)

	var desired_pos: Vector3 = target.global_position + base_offset + mouse_offset
	global_position = global_position.lerp(desired_pos, smooth_speed * delta)
	look_at(target.global_position + mouse_offset, Vector3.UP)
