extends Node

const MAX_LOGS_SIZE = 250

var consoleOpened := false
var consoleLogs   := PoolStringArray()

var debugInstace = preload("res://debug/DebugInterface.tscn").instance()
onready var debugLog = debugInstace.get_node("Control/LogTerminal")


func _input(event):
  if event is InputEventKey:
    if event.is_action_pressed("open_terminal"):
      consoleOpened = !consoleOpened
      debugInstace.visible = consoleOpened

func _ready():
  debugInstace.visible = consoleOpened
  debugLog.text = ""
  get_tree().get_root().call_deferred("add_child", debugInstace)

func print(value):
  var cTime   = OS.get_time()
  var hour    = String(cTime.hour).pad_zeros(2)
  var minute  = String(cTime.minute).pad_zeros(2)
  var second  = String(cTime.second).pad_zeros(2)
  
  consoleLogs.append("[%s:%s.%s] %s" % ([hour, minute, second, value]))
  if (consoleLogs.size() > MAX_LOGS_SIZE):
    consoleLogs.remove(0)
  debugLog.text = consoleLogs.join("\n")
