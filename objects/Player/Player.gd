extends KinematicBody

# Player variables
var items           : PoolStringArray = PoolStringArray()
var pickableObject  : TheItem         = null

# Constants
const SPEED         : float = 7.0
const ACCELERATION  : float = 0.1
const DECELERATION  : float = 0.3
const RUN_MULTIPLY  : float = 1.5
const ANGLE_MIN     : float = -75.0
const ANGLE_MAX     : float = +75.0
const GRAVITY       : float = 9.8 * 6

# Physics variables
var direction : Vector3 = Vector3.ZERO
var velocity  : Vector3 = Vector3.ZERO
var yvelocity : Vector3 = Vector3.ZERO

# States
var isRunning : bool = false

# Nodes
onready var nAnimTree         : AnimationTree     = $AminTree
onready var nCameraPivot      : Spatial           = $CameraPivot
onready var nCamera           : Camera            = $CameraPivot/Camera
onready var nCrosshair        : Control           = $GUI/Crosshair
onready var nSFXPickItem      : AudioStreamPlayer = $Sounds/SFX/PickItem
onready var nRayPickableItem  : RayCast           = (
  $CameraPivot/Camera/Rays/PickableItem)

# Animation
onready var stateMachine      : AnimationNodeStateMachinePlayback = (
  nAnimTree.get("parameters/playback"))

func _ready():
  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
  if event is InputEventMouseMotion:
    rotate_y(-deg2rad(event.relative.x) * Configurations.MOUSE_SENSITIVITY_X)
    nCameraPivot.rotate_x(
      -deg2rad(event.relative.y) * Configurations.MOUSE_SENSITIVITY_Y)
    nCameraPivot.rotation_degrees.x = (
      clamp(nCameraPivot.rotation_degrees.x, ANGLE_MIN, ANGLE_MAX))

func _physics_process(delta):
  # JOYSTICK CAMERA MOVEMENT
  var joyCamY = (
    Input.get_action_strength("joy_cam_up") -
    Input.get_action_strength("joy_cam_down")
  ) * (10 * Configurations.JOY_SENSITIVITY_Y)
  var joyCamX = (
    Input.get_action_strength("joy_cam_left") -
    Input.get_action_strength("joy_cam_right")
  ) * (10 * Configurations.JOY_SENSITIVITY_X)
  rotate_y(joyCamX * delta)
  nCameraPivot.rotate_x(joyCamY * delta)
  nCameraPivot.rotation_degrees.x = clamp(
    nCameraPivot.rotation_degrees.x, ANGLE_MIN, ANGLE_MAX)

  var moveY := (
    Input.get_action_strength("move_forward") -
    Input.get_action_strength("move_backward"))
  var moveX := (
    Input.get_action_strength("move_left") -
    Input.get_action_strength("move_right"))

  direction *= 0
  direction -= moveY * transform.basis.z
  direction -= moveX * transform.basis.x
  direction = direction.normalized()
  var accel = ACCELERATION if direction.length() else DECELERATION
  var speed = SPEED if !isRunning else SPEED * RUN_MULTIPLY
  velocity  = velocity.linear_interpolate(direction * speed, accel)
  velocity  = move_and_slide(Vector3(velocity.x, 0, velocity.z), Vector3.UP, true)

  # RUN
  if direction.length() && moveY > 0:
    if Input.is_action_just_pressed("move_run"): isRunning = true
  else:
    isRunning = false
  
  # GRAVITY
  yvelocity = move_and_slide(Vector3(0, yvelocity.y, 0), Vector3.UP, true)
  if (!is_on_floor()):
    yvelocity.y -= GRAVITY * delta
  else:
    yvelocity.y = -0.1

  if !direction.length():
    if stateMachine.get_current_node() != "Idle": stateMachine.travel("Idle")
  else:
    if !isRunning:
      if stateMachine.get_current_node() != "Walk": stateMachine.travel("Walk")
    else:
      if stateMachine.get_current_node() != "Run": stateMachine.travel("Run")
  
  pickableObjectProccess()

# Pickable
func pickableObjectProccess(_delta = get_process_delta_time()):
  if nRayPickableItem.is_colliding():
    if nRayPickableItem.get_collider().has_method("turnOutline"):
      seePickableObject()
      if Input.is_action_just_pressed("pick"):
        pickObject()
    else:
      unseePickableObject()
  elif pickableObject:
    unseePickableObject()

  if pickableObject:
    nCrosshair.show()
  else:
    nCrosshair.hide()

func seePickableObject():
  if !pickableObject:
    pickableObject = nRayPickableItem.get_collider()
    pickableObject.turnOutline(true)
    Debug.print("Seeing Object")

func unseePickableObject():
  if pickableObject:
    pickableObject.turnOutline(false)
    pickableObject = null
    Debug.print("Unseeing Object")

func pickObject():
  PlayerGlobals.itemAdd(pickableObject)
  pickableObject.pick()
  pickableObject = null
  nSFXPickItem.play(0)
  Debug.print("Object Picked")


