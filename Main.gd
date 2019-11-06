 extends Spatial

onready var angle_meter = get_node("Control/angle")
onready var power_meter = get_node("Control/power")
onready var t = get_node("Timer")
onready var hit_display = get_node("Control/hit")
onready var ball = get_node("RigidBody")

var power_value = 0
var angle_value = 0

var step = 0
var value_increment = 1
var coll_counter = 0
var start_again = 3

func _ready():
	pass
	
func _process(delta):
	if(step == 0):
		angle_value+=value_increment*delta*200
		if( angle_value>99 or angle_value<1):
			value_increment *= -1
		angle_meter.value = angle_value
		if(Input.is_action_pressed("ui_accept")):
			t.set_wait_time(0.4)
			t.start()
			value_increment =1
			step = 11
#			angle_value = 50
	if(step == 1):
		power_value+=value_increment*delta*200
		if( power_value>99 or power_value<1):
			value_increment *= -1
		power_meter.value = power_value
		if(Input.is_action_pressed("ui_accept")):
			t.set_wait_time(0.4)
			t.start()
			value_increment =1
			step = 12
	if(step == 2):
		print(angle_value,":",power_value)
		
		ball.apply_central_impulse(Vector3(0,10,-sqrt(power_value)).rotated(Vector3(0,1,0),-((angle_value-50)/200.0)*PI))
		print(Vector3(0,10,-sqrt(power_value)).rotated(Vector3(0,1,0),0*PI))
		step+=1
	if(step == 3):
		var colls = ball.get_colliding_bodies()
		if(colls.size()>0):
			coll_counter+=1
			for collider in colls:
				if ("Target" in collider.name):
					hit_display.visible = true
					step+=10
					t.set_wait_time(0.4)
					t.start()
			if(coll_counter==3):
				t.set_wait_time(1)
				t.start()

func _on_Timer_timeout():
	step -=10
	hit_display.visible = false
	
	if(start_again<=0):
		get_tree().reload_current_scene()
	if(coll_counter>=3):
		start_again-=1
		hit_display.text = "Restart in "+str(start_again)+"s"
		hit_display.visible = true
		t.set_wait_time(1)
		t.start()
	
	
