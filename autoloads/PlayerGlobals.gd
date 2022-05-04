extends Node
signal onItemsListModified(node_or_null_modified)

var item1 : TheItem = null
var item2 : TheItem = null
var item3 : TheItem = null
var item4 : TheItem = null
var item5 : TheItem = null
var item6 : TheItem = null

func itemAdd(itemNode: TheItem):
  Debug.print("Player items: added '%s'" % [itemNode])
  var newNode = itemNode.duplicate() as TheItem
  newNode.pickable = false
  newNode._ready()
  match null:
    item1: item1 = newNode
    item2: item2 = newNode
    item3: item3 = newNode
    item4: item4 = newNode
    item5: item5 = newNode
    item6: item6 = newNode
  emit_signal("onItemsListModified", newNode)
  
func itemRemove(caseId: int):
  Debug.print("Player items: clear case '%s'" % [caseId])
  match caseId:
    1: item1 = null
    2: item2 = null
    3: item3 = null
    4: item4 = null
    5: item5 = null
    6: item6 = null
  emit_signal("onItemsListModified", caseId)
