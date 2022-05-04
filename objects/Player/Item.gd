extends Spatial

export var cameraNode : NodePath

onready var nPosPivot       := $PosPivot
onready var nPos 			      := $PosPivot/Pos
onready var nCamera         := get_node(cameraNode) as Camera
onready var nItemContainer  := $PosPivot/Pos/ItemContainer

onready var _player_onItemsListModified := PlayerGlobals.connect(
  "onItemsListModified", self, "player_onItemsListModified")

func _ready():
  nPos.set_as_toplevel(true)

func _process(delta):
  nPos.global_transform.origin = (nPosPivot.global_transform.origin
    - Vector3(nCamera.rotation_degrees.z * .05, abs(
      nCamera.rotation_degrees.z * .05), 0))
  nPos.global_transform = nPos.global_transform.interpolate_with(
    nPosPivot.global_transform, 20 * delta)

func player_onItemsListModified(modified: TheItem):
  if modified:
    modified.transform.origin *= 0
    modified.rotation_degrees *= 0
    nItemContainer.add_child(modified)

