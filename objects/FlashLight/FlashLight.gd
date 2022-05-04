extends TheItem

func _ready():
  if pickable:
    $PickableFX.show()
    $NonPickableFX.hide()
  else:
    $PickableFX.hide()
    $NonPickableFX.show()