class_name Hud3D extends Area3D

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var subviewport: SubViewport = $SubViewport

var mesh_size: Vector2

var is_mouse_on := false
var current_mouse_position := Vector2.ZERO

func _ready():
    var aabb_size = mesh.mesh.get_aabb().size
    mesh_size = Vector2(aabb_size.x, aabb_size.y)

# Called when mouse is visible and raycast hit this node.
func _input_event(_camera: Camera3D, event: InputEvent, event_position: Vector3, _event_normal: Vector3, _shape_index: int):
    if event is InputEventMouse:
        var mouse_position = world_to_viewport(event_position)
        event.position = mouse_position
        subviewport.push_input(event)

func _unhandled_input(event):
    if is_mouse_on:
        # Send mouse clicks to hud viewport.
        if event is InputEventMouseButton && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
            event.position = current_mouse_position
            subviewport.push_input(event)
        # Send key events to hud viewport
        elif event is InputEventKey:
            subviewport.push_input(event)

func _process(_delta):
    var ray = get_camera_ray(5)
    var result = raycast(ray.origin, ray.end)
    if !result.is_empty() && result.collider == self:
        is_mouse_on = true
        var mouse_position = world_to_viewport(result.position)
        current_mouse_position = mouse_position
        # Only send event if mouse is captured.
        if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
            var event = InputEventMouseMotion.new()
            event.position = mouse_position
            subviewport.push_input(event)
    else:
        is_mouse_on = false

func world_to_viewport(world_position: Vector3) -> Vector2:
    var local_position := to_local(world_position)
    var mesh_half_size := mesh_size / 2.0
    var normalized_position := Vector2(
        (local_position.x + mesh_half_size.x) / mesh_size.x,
        (-local_position.y + mesh_half_size.y) / mesh_size.y)
    return subviewport.size as Vector2 * normalized_position

func get_camera_ray(ray_dist: float):
    var viewport = get_viewport()
    var cam = viewport.get_camera_3d()
    var mousepos = viewport.get_mouse_position()

    var origin = cam.project_ray_origin(mousepos)
    var end = origin + cam.project_ray_normal(mousepos) * ray_dist
    return {
        "origin": origin,
        "end": end
    }

func raycast(origin: Vector3, end: Vector3, mask: int = 4294967295, exlude: Array[RID] = []) -> Dictionary:
    var query = PhysicsRayQueryParameters3D.create(origin, end, mask, exlude)
    query.collide_with_areas = true
    return get_world_3d().direct_space_state.intersect_ray(query)
