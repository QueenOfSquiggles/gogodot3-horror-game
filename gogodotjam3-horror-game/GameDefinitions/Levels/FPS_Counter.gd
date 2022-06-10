extends PanelContainer

onready var counter := $Label

var progressive_average := []
const AVERAGE_RANGE := 100

func _process(_delta: float) -> void:
	var fps := Engine.get_frames_per_second()
	if Engine.get_idle_frames() % 60 == 0:
		progressive_average.push_front(fps)
		while progressive_average.size() >= AVERAGE_RANGE:
			progressive_average.pop_back()
	var avg := 0.0
	if progressive_average.size() >= 5:
		for time in progressive_average:
			avg += time
		avg /= float(progressive_average.size())
	counter.text = "FPS: %s\nAVG: %s" % [str(floor(fps)),str(floor(avg))]
