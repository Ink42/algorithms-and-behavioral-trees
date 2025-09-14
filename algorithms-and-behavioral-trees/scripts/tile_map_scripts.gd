extends TileMapLayer

var allowed_movements = [Vector2i.DOWN,Vector2i.UP,Vector2i.RIGHT,Vector2i.LEFT]
@onready var timer: Timer = $"../Timer"

var cell = Vector2i.ZERO
var source_id = Vector2.ZERO
var tile_id = 0
var wall_id = 1
var visted_nodes:Array[Vector2i] =[]
var wall_nodes:Array[Vector2i]=[]
var back_track_index =-1


func _ready():
	var default_node= Vector2i(2, 2)
	set_cell(default_node,0,Vector2i(0,0))
	visted_nodes.append(default_node)
	timer.start(0.01)
	wall_nodes = get_used_cells_by_id(wall_id)

func _process(delta: float) -> void:
	pass

func neigbours():
	
	var last_location = visted_nodes.back()
	var  temp  = null
	var counter =0
	allowed_movements.shuffle()
	for i in allowed_movements:
		temp = last_location + i
		if temp in visted_nodes or temp in wall_nodes:
			counter+=1
			printerr("Positon occupid ", temp)
		else :
				place_node(temp,source_id,tile_id)
				visted_nodes.append(temp)
				
				print("placed node at ", temp)
				
				temp = null
				
				break
	if counter>=4:
		print_rich("/wave Trapped")
		# go back on step and see if theres any open tiles
		#go back ...pop..check
		var duplicate_array = visted_nodes.duplicate()
		
		while duplicate_array.size() >0 :
			var question_node = duplicate_array.pop_back()
			for y in allowed_movements:
				temp = question_node + y
				print_rich("[color=green][b]RETARCE![/b][/color]")
				if temp not in visted_nodes and temp not in wall_nodes:
					place_node(temp,source_id,tile_id)
					visted_nodes.append(temp)
					print("placed node at ", temp)
					return
				
					temp = null
				else:
					print("Retacing steps")
		get_tree().paused = true
func place_node(nodeposition:Vector2i,sourceid:Vector2i,tileid):
	set_cell(nodeposition,tileid,sourceid)


func add_to_has_been_visted(node:Vector2i)->void:
	visted_nodes.append(node)

func _on_timer_timeout() -> void:
	print("Time!", (back_track_index))
	neigbours()
