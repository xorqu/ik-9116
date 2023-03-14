extends DirectionalLight


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _physics_process(delta):
	time += delta
	rotate_y(0.0005)
	self.light_energy = 0.5 + sin(time)*0.3
