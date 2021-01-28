extends Control



onready var healthBar = $HealthBar
onready var shieldBar = $ShieldBar


func _ready() -> void:
	EventManager.connect("player_health_changed", self, "_on_player_health_changed")
	EventManager.connect("player_shield_changed", self, "_on_player_shield_changed")
	return
	
	
	
func _on_player_health_changed(newHealthPercentage: float) -> void:
	print(newHealthPercentage)
	healthBar.value = newHealthPercentage
	return
	
func _on_player_shield_changed(newShieldPercentage: float) -> void:
	shieldBar.value = newShieldPercentage
	return
