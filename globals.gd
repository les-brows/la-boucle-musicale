extends Node

var CAMERA_SPEED = 0.5
var LEVEL_SIZE = 5000

const BPM_SUBDIVISION : int = 8
const BASE_BPM : int = 200
const BPM: int = BPM_SUBDIVISION * BASE_BPM

@warning_ignore("unused_signal")
signal beat_launched(num_beat: int)
@warning_ignore("unused_signal")
signal middle_level_reached()
@warning_ignore("unused_signal")
signal end_level_reached()
@warning_ignore("unused_signal")
signal player_death()
 

var MAX_HP: float = 10
var INVINCIBILITY_TIMER: float= 1
