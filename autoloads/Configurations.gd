extends Node

const MOUSE_SENSITIVITY_Y : float = 0.1
const MOUSE_SENSITIVITY_X : float = 0.1

const JOY_SENSITIVITY_Y : float = 0.4
const JOY_SENSITIVITY_X : float = 0.4

func _ready():
  OS.window_maximized = true