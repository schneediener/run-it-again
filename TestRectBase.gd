extends Node2D

var dragging = false  # Are we currently dragging?
var selected = []  # Array of selected units.
var drag_start  # Location where drag began.
var select_rect = RectangleShape2D.new()  # Collision shape for drag box.

func _process(delta):
		if Input.is_action_pressed("ui_left"):
			$Camera2D.position.x += -10
		if Input.is_action_pressed("ui_right"):
			$Camera2D.position.x += 10
		if Input.is_action_pressed("ui_up"):
			$Camera2D.position.y += -10
		if Input.is_action_pressed("ui_down"):
			$Camera2D.position.y += 10

func _unhandled_input(event):
	
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			# We only want to start a drag if there's no selection.
			if selected.size() == 0:
				dragging = true
				drag_start = get_global_mouse_position()
		elif dragging:
			dragging = false
			update()
			var drag_end = get_global_mouse_position()
			select_rect.extents = (drag_end - drag_start) / 2
			var space = get_world_2d().direct_space_state
			var query = Physics2DShapeQueryParameters.new()
			query.set_shape(select_rect)
			query.transform = Transform2D(0, (drag_end + drag_start) / 2)
			var intersect_query = space.intersect_shape(query)
			var towers = []
			for each in intersect_query:
				if each.collider.type == "tower":
					selected.append(each.collider)
			if selected.size()>0:
				mass_select_towers(selected)
			selected = []
	if event is InputEventMouseMotion and dragging:
		update()
	if event.is_action_pressed("ig_scroll_down"):
		$Camera2D.zoom -= Vector2(0.1,0.1)
	if event.is_action_pressed("ig_scroll_up"):
		$Camera2D.zoom += Vector2(0.1,0.1)
func mass_select_towers(array):
	pass
func _draw():
	if dragging:
		var mouse_pos = get_global_mouse_position()
		draw_rect(Rect2(drag_start, mouse_pos - drag_start),
				Color(.5, .5, .5), false)
