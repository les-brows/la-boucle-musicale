extends Node

var CAMERA_SPEED = 1
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
var ENEMY_MOVEMENT_SPEED: float = 0.0005

var INVINCIBILITY_TIMER: float = 1
var MAX_HP: int = 10
 
const INITIAL_LOOP_COUNT: int = 0
var LOOP_COUNT: int = INITIAL_LOOP_COUNT

var COOLDOWN_DASH=2
var DASH_TIME=0.4
var SPEED_DASH_MAX=1200
var NORMAL_SPEED_PLAYER = 800.0
var HEALTHBAR_TWEEN_TIMEOUT = 0.5


var DMG_BULLET  : int =1
var MOVE_SPEED_MULT_PLAYER: float =1
var MOVE_SPEED_MULT_ENEMY: float=1
var BULLET_TRAVEL_MULT_PLAYER : float =1
var BULLET_TRAVEL_MULT_ENEMY : float =1
var CURRENT_HP_PLAYER : int =MAX_HP
var BULLET_SIZE_MULT_PLAYER :float =1
var BULLET_SIZE_MULT_ENEMY :float =1
var NB_BULLET_PLAYER =1
