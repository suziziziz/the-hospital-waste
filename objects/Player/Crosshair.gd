extends Control

func _ready():
	hide()

func _draw():
	draw_circle((rect_size / 2).round(), 2, Color(1, 1, 1, 0.5))
