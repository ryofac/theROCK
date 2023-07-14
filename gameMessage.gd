extends Label

onready var timer = get_node("Timer")
onready var animator = get_node("Animator")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.connect("timeout", self, "timeout")
	animator.connect("animation_finished", self, "animation_finished")
	animator.play("appearing")


func timeout():
	animator.play("disappearing")
	

func animation_finished(_anim):
	if (_anim == "disappearing"):
		queue_free()
	elif (_anim == "appearing"):
		timer.start()
