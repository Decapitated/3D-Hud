extends Node3D

@onready var camera: Camera3D = $Camera3D

var is_escaped := false

func _process(_delta):
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if is_escaped else Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event):
    if event is InputEventMouseMotion:
        if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
            rotate_y(-event.relative.x * 0.001)
            camera.rotate_x(-event.relative.y * 0.001)
    elif event is InputEventKey:
        if event.pressed and event.keycode == KEY_ESCAPE:
            is_escaped = !is_escaped