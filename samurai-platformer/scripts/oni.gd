extends CharacterBody2D

@onready var flipper: Node2D = $Flipper
@onready var anim: AnimatedSprite2D = $Flipper/AnimatedSprite2D
@onready var raywall: RayCast2D = $Flipper/raywall
@onready var rayfloor: RayCast2D = $Flipper/rayfloor
@onready var rayspikes: RayCast2D = $Flipper/rayspikes
@onready var rayattack: RayCast2D = $Flipper/rayattack
@onready var attack_hitbox: Area2D = $Flipper/attack_hitbox

enum State { IDLE, PATROL, CHASE, READY, ATTACK, HURT, DEAD }
var state: State = State.IDLE
var direction= -1
var life = 5
var attack_power = 1
var patrol_time = 0.0
const SPEED = 150.0

var attack_cooldown = 1.0 
var attack_timer = 0.0

func _ready():
	state=State.IDLE
	anim.play("idle")
func _physics_process(delta: float) -> void:
	attack_timer -= delta
	if attack_timer < 0:
		attack_timer = 0
	proccess_state(delta)
	apply_movement()
	apply_gravity(delta)
	
		
	


func apply_movement():
	move_and_slide()
func apply_gravity(delta):
	if not is_on_floor():	
		velocity += get_gravity() * delta
	else:
		velocity.y = 0
		
#MAQUINA ESTADOS-------------------------------------------------------------------
func proccess_state(delta):
	match state:
		State.IDLE:
			state_idle(delta)
		State.PATROL:
			state_patrol(delta)
		State.CHASE:
			state_chase(delta)
		State.READY:
			state_ready(delta)
		State.ATTACK:
			state_attack(delta)
		State.HURT:
			state_hurt(delta)
		State.DEAD:
			state_dead(delta)
	#ESTADOS----------------------------------------------------------------------------
func state_idle(_delta):
	play_anim("idle")
	velocity.x=0
	
func state_patrol(_delta):
	if patrol_time <= 0.0:
		patrol_time = randf_range(3.0,10.0)
		
	play_anim("patrol")
	velocity.x = direction * SPEED 
	if should_turn():
		turn()
	
	patrol_time -= _delta
	if patrol_time <= 0.0:
		state = State.IDLE
	
func state_chase(_delta):
	play_anim("chase")
	
	if GameManager.player:
		set_direction(sign(GameManager.player.global_position.x - global_position.x))
		
		var can_move = rayfloor.is_colliding() and not raywall.is_colliding() and not rayspikes.is_colliding()
		velocity.x = direction * SPEED * 1.3 if can_move else 0.0
		
		if rayattack.is_colliding():
			state = State.READY
			
		if not can_move:
			velocity.x = 0
			state = State.IDLE
func state_ready(_delta):
	velocity.x = 0
	play_anim("ready")
		
	if attack_timer == 0:
		state = State.ATTACK
func state_attack(_delta):
	velocity.x = 0
	play_anim("attack")
	if anim.frame == 2 or anim.frame == 6:
		attack_hitbox.monitoring = true
	else:
		attack_hitbox.monitoring = false
		
	var frames = anim.sprite_frames.get_frame_count("attack")
	if anim.frame == frames -1:
		state = State.CHASE
		attack_timer = attack_cooldown
func state_hurt(_delta):
	play_anim("hurt")
	velocity.x = 0
	
func state_dead(_delta):
	play_anim("die")
	velocity = Vector2.ZERO
#LOGICA----------------------------------------------------------------------------

func play_anim(anim_name : String):
	if anim.animation != anim_name:
		anim.play(anim_name)
		
func take_damage(amount):
	if state == State.DEAD:
		return
	life -= amount
	if life <= 0 :
		state = State.DEAD
	else:
		state = State.HURT
	
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is DrunkMaster:
		state = State.CHASE
		
func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is DrunkMaster:
		state = State.PATROL
		
func should_turn() -> bool :
	if raywall.is_colliding() or rayspikes.is_colliding():
		return true
	if not rayfloor.is_colliding():
		return true
	return false
	
func turn():
	direction *= -1
	set_direction(direction)
	
func set_direction(dir):
	if dir == 0:
		return
	direction = dir 
	flipper.scale.x = 1 if dir > 0 else -1
	


func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body is DrunkMaster:
		var drunkmaster:DrunkMaster = body as DrunkMaster
		drunkmaster.take_damage(attack_power)
