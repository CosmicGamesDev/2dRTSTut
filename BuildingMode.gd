extends Node2D

@export var building_area := Rect2(0,0,16,16)
@export var parent_building : Node2D
var query_rect = RectangleShape2D.new()
var can_build = []
var has_built = false

signal build_building

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("build") && can_build.size() == 0:
		build_building.emit()
		has_built = true
		queue_redraw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !has_built:
		parent_building.global_position = get_global_mouse_position()
		building_area.position = -(building_area.size/2)
		var space = get_world_2d().direct_space_state
		query_rect.extents = abs(building_area.size)/2
		var q = PhysicsShapeQueryParameters2D.new()
		q.shape = query_rect
		q.collision_mask = 2
		q.transform = Transform2D(0,get_global_mouse_position())
		can_build = space.intersect_shape(q)
		queue_redraw()

func _draw():
	if can_build.size() == 0 && !has_built:
		draw_rect(building_area, Color(0,1,0,.5))
	elif !has_built:
		draw_rect(building_area,Color(1,0,0,.5))
	else:
		draw_rect(building_area,Color.TRANSPARENT)
