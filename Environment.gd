extends WorldEnvironment


func _ready():
  environment = preload("res://env_default.tres")
  $DirectionalLight.light_color = Color("090909")
  $DirectionalLight2.light_color = Color("090909")
