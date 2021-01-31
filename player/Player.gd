extends KinematicBody2D

### State

var health: float = 100
var maxHealth: float = 100
var shield: float = 50
var maxShield: float = 50

### Movement
var MAX_SPEED: float = 60
var ACCELERATION: float = 200
var FRICTION: float = 200
var velocity: Vector2 = Vector2.ZERO

### Animation
onready var animPlayer = $AnimationPlayer
onready var animTree = $AnimationTree
onready var animState: AnimationNodeStateMachinePlayback = animTree.get("parameters/playback")


func _ready() -> void:
	EventManager.connect("player_opened_container", self, "_on_player_opened_container")
	return


func _process(delta) -> void:
	handle_move()
	return


func _input(event) -> void:
	_handle_toggle_inventory_action(event)
	_handle_mouse_wheel_action(event)
	return


### Accessor / Mutator

func modify_health(amount: int) -> void:
	if amount < 0:
		health = max(0, health + amount)
	else:
		health = min(health + amount, maxHealth)
	var healthPercentage = (health/maxHealth) * 100
	EventManager.emit_signal("player_health_changed", healthPercentage)
	return

func modify_shield(amount: int) -> void:
	if amount < 0:
		shield = max(0, shield + amount)
	else:
		shield = min(shield + amount, maxShield)
	var shieldPercentage = float(shield/maxShield) * 100
	EventManager.emit_signal("player_shield_changed", shieldPercentage)
	return

### Events




func _block_movement_input() -> bool:
	return PlayerManager.should_block_movement()

func handle_move() -> void:

	var input_vector = Vector2.ZERO

	if !_block_movement_input():
		input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	var input_vector_n = input_vector.normalized()

	if input_vector_n != Vector2.ZERO:
		animTree.set("parameters/Idle/blend_position", input_vector_n)
		animTree.set("parameters/Run/blend_position", input_vector_n)
		velocity = velocity.move_toward(input_vector_n * MAX_SPEED, ACCELERATION * get_process_delta_time())
		#animState.travel("Run")
	else:
		animState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * get_physics_process_delta_time())

	velocity = move_and_slide(velocity)
	return

func _handle_toggle_inventory_action(event) -> void:
	if event.is_action_released("toggle_inventory"):
		EventManager.emit_signal("inventory_toggled")
	return

func _handle_mouse_wheel_action(event) -> void:
	if event.is_action_released("mouse_wheel_up"):
		EventManager.emit_signal("hotbar_previous_item_selected")
	if event.is_action_released("mouse_wheel_down"):
		EventManager.emit_signal("hotbar_next_item_selected")
	return

func pickup_item(item) -> void:
	EventManager.emit_signal("player_picked_up_item", item)
	return

# only collides with items in world
func _on_ItemCollision_body_entered(body) -> void:
	pickup_item(body)
	return

func left_clicked_object(otherObject) -> void:
	if _is_in_range(otherObject.get_global_position()):
		print("LC In range: ", otherObject.name)
		otherObject.on_interact()
	else:
		print("LC Not in range: ", otherObject.name)
		modify_health(-5)
		modify_shield(-10)
	return

func right_clicked_object(otherObject) -> void:
	if _is_in_range(otherObject.get_global_position()):
		otherObject.on_interact()
	else:
		print("RC Not in range: ", otherObject.name)
	return

func on_interact(itemInHand) -> void:
	if itemInHand is Item && itemInHand.type == Constants.ItemType.CONSUMABLE:
		itemInHand.on_consume_item()
	return
