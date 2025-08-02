extends Node

var CAMERA_SPEED = 0.5

const BPM_SUBDIVISION : int = 8
const BASE_BPM : int = 175
const BPM: int = BPM_SUBDIVISION * BASE_BPM

@warning_ignore("unused_signal")
signal beat_launched(num_beat: int)
