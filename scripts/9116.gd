extends Spatial


onready var tree = $QodotMap/entity_1_func_group

onready var sph1 = $QodotMap/entity_30_func_group
onready var sph2 = $QodotMap/entity_31_func_group
onready var sph3 = $QodotMap/entity_32_func_group
#onready var sph4 = $QodotMap/entity_19_func_group
#onready var sph5 = $QodotMap/entity_20_func_group
#onready var sph6 = $QodotMap/entity_21_func_group
#onready var sph7 = $QodotMap/entity_22_func_group
#onready var sph8 = $QodotMap/entity_23_func_group

onready var timer = $triggers/Timer
onready var ctimer = $triggers/compl_timer
onready var ctimer_off = $triggers/compl_timer_off
onready var door = $door

onready var sphes = [sph1, sph2, sph3]

var tr = [false, false, false, false]

var is_compl = false

var time = 0

func _ready():
	pass

func compl():
	$triggers/compl.play(0)
	ctimer_off.start(2)
	print('complited')

func door_open():
	door.queue_free()


func _physics_process(delta):
	
	time += delta
	
	tree.rotate_y(0.005)
	tree.translation.y = 5 + sin(time)
	
	if tr[0] and tr[1] and tr[2] and tr[3] and !is_compl:
		ctimer.start(2)
		is_compl = true
		print('arr check')
	
	for i in range(3):
		sphes[i].translate_object_local(Vector3(0,sin(time)*0.02,0))


func _on_Area1_body_entered(body):
	if body.is_in_group('player'):
		tr[0] = true
		$triggers/Area1/trigger_sound1.play(0)
		timer.start(1.8)


func _on_Area2_body_entered(body):
	if body.is_in_group('player'):
		tr[1] = true
		$triggers/Area2/trigger_sound2.play(0)
		timer.start(1.8)

func _on_Area3_body_entered(body):
	if body.is_in_group('player'):
		tr[2] = true
		$triggers/Area3/trigger_sound3.play(0)
		timer.start(1.8)

func _on_Area4_body_entered(body):
	if body.is_in_group('player'):
		tr[3] = true
		$triggers/Area4/trigger_sound4.play(0)
		timer.start(1.8)


func _on_Timer_timeout():
	$triggers/Area1/trigger_sound1.stop()
	$triggers/Area2/trigger_sound2.stop()
	$triggers/Area3/trigger_sound3.stop()
	$triggers/Area4/trigger_sound4.stop()
	timer.stop()


func _on_compl_timer_timeout():
	compl()
	ctimer.stop()


func _on_compl_timer_off_timeout():
	$triggers/compl.stop()
	print('compl timer off')
	ctimer_off.stop()
	door_open()


func _on_Area_body_entered(body):
	if body.is_in_group('player'):
		get_tree().change_scene("res://scenes/final.tscn")
