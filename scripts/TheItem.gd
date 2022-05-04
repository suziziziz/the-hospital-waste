extends Area
class_name TheItem

export var itemName 		: String = "base"
export var pickable     : bool   = true
export var outlineNode	: NodePath
export var colliderNode : NodePath

onready var nCollider := get_node(colliderNode) as CollisionShape
onready var nOutline  := get_node(outlineNode) as Node

var isPicked : bool = false

func _ready():
  if pickable:
    if !isPicked:
      nOutline.visible = false
  else:
    nOutline.visible = false
    isPicked = true
    nCollider.disabled = true

func turnOutline(value: bool):
  if pickable:
    if !isPicked:
      nOutline.visible = value

func _process(_delta):
  if pickable:
    if isPicked:
      scale -= Vector3.ONE * .1
      if scale.x <= 0:
        queue_free()

func pick():
  if pickable:
    isPicked = true
    nOutline.visible = false
    nCollider.disabled = true
