extends Object

class_name Partition

var beat_subdivision: int = 4
var curr_beat_index: int = 0
var max_beat_in_partition: int = 0
var partition_duration: int = 0

var list_note: Array[Note] = []

# THE NOTES HAVE TO BE IN THE RIGHT ORDER
func _init(_beat_subdivision: int, _partition_duration: int, _list_notes: Array[Note]) -> void:
	beat_subdivision = _beat_subdivision
	partition_duration = _partition_duration
	list_note = _list_notes
	max_beat_in_partition = list_note[-1].beat_number

func get_next_beat(beat: int) -> int:
	var beat_offset = ceili(beat / float(beat_subdivision)) % partition_duration
	var pre_partition_offset = beat - beat % (beat_subdivision * partition_duration)
	var next_bar: bool = false
	
	if(beat_offset > max_beat_in_partition):
		curr_beat_index = 0
		next_bar = true
	else:
		for index in list_note.size():
			if(beat_offset <= list_note[index].beat_number):
				curr_beat_index = index
				break
	
	var offset_in_partition = list_note[curr_beat_index].beat_number + (partition_duration if next_bar else 0)
	
	return offset_in_partition * beat_subdivision + pre_partition_offset

func get_curr_note() -> Note:
	return list_note[curr_beat_index]
