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
@warning_ignore("unused_signal")
signal player_damage()
@warning_ignore("unused_signal")
signal enemy_damage()

var BOUNDARY_LOW: int = 45
var BOUNDARY_UP: int = 600

var ENEMY_MAXHP: int = 3

var INVINCIBILITY_TIMER: float = 1
var MAX_HP: int = 10
 
var LOOP_COUNT: int = 0
