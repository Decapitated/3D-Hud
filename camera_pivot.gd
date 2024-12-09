extends Node3D

@onready var camera: Camera3D = $Camera3D

func _ready():
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
    if event is InputEventMouseMotion:
        if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
            rotate_y(-event.relative.x * 0.001)
            camera.rotate_x(-event.relative.y * 0.001)
    elif event is InputEventKey:
        if event.pressed and event.keycode == KEY_ESCAPE:
            if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
                Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
            else:
                Input.mouse_mode = Input.MOUSE_MODE_CAPTURED