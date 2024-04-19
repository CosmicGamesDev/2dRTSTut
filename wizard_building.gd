extends Sprite2D

@export var unit_scene_path = "res://unit.tscn"
var loaded_unit : PackedScene
var is_building = true
@onready var building_mode := $BuildingMode
@onready var animation_player = $AnimationPlayer
@onready var progress_bar = $ProgressBar
@onready var spawn_timer = $SpawnTimer


# Called when the node enters the scene tree for the first time.
func _ready():
	loaded_unit = load(unit_scene_path)
	building_mode.build_building.connect(_set_building_mode)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress_bar.value = -(spawn_timer.time_left - progress_bar.max_value)


func _on_spawn_timer_timeout():
	if !is_building:
		var new_unit = loaded_unit.instantiate()
		get_tree().root.add_child(new_unit)
		new_unit.global_position = $SpawnPosition.global_position

func _set_building_mode():
	is_building = false
	$StaticBody2D/CollisionShape2D.disabled = false
	$StaticBody2D/CollisionShape2D2.disabled = false
	spawn_timer.start()
	progress_bar.max_value = spawn_timer.time_left
	animation_player.play("building")
