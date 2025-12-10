extends CharacterBody2D
class_name DrunkMaster

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

# Estados
enum State { IDLE, RUN, JUMP, FALL, WALLSLIDE, HURT, DEAD }
var state: State = State.IDLE

var life = 10
const SPEED = 250.0
const JUMP_VELOCITY = -330.0
const WALL_JUMP_PUSHBACK = 100.0
const WALL_SLIDE_GRAVITY = 100.0

func _physics_process(delta: float) -> void:
	if state == State.DEAD:
		return
	
	# Aplicar gravedad siempre
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	handle_input()
	move_and_slide()
	update_state()
	play_animation()

# ---------------------------
# INPUTS
# ---------------------------
func handle_input():
	if state in [State.HURT, State.DEAD]:
		return  # bloquea inputs durante knockback o muerte

	var dir := Input.get_axis("move_left", "move_right")
	velocity.x = dir * SPEED if dir != 0 else move_toward(velocity.x, 0, SPEED)
	if dir != 0:
		anim.flip_h = dir < 0

	if Input.is_action_just_pressed("jump"):
		_jump()

func _jump():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif is_on_wall():
		velocity.y = JUMP_VELOCITY
		if Input.is_action_pressed("move_right"):
			velocity.x = -WALL_JUMP_PUSHBACK
		elif Input.is_action_pressed("move_left"):
			velocity.x = WALL_JUMP_PUSHBACK

# ---------------------------
# ESTADOS
# ---------------------------
func update_state():
	if life <= 0:
		state = State.DEAD
	elif is_on_wall() and not is_on_floor() and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		state = State.WALLSLIDE
	elif not is_on_floor():
		state = State.JUMP if velocity.y < 0 else State.FALL
	else:
		state = State.RUN if velocity.x != 0 else State.IDLE

# ---------------------------
# ANIMACIONES
# ---------------------------
func play_animation():
	match state:
		State.IDLE: anim.play("idle")
		State.RUN: anim.play("run")
		State.JUMP: anim.play("jump")
		State.FALL: anim.play("fall")
		State.WALLSLIDE: anim.play("wallslide")
		State.HURT: anim.play("hurt")
		State.DEAD: anim.play("die")

# ---------------------------
# DAÑO Y KNOCKBACK
# ---------------------------
func take_damage(damage: int, from_position: Vector2):
	if life <= 0:
		return  # ya muerto

	life -= damage
	
	if life <= 0:
		state = State.DEAD
		anim.play("die")
		await get_tree().create_timer(0.5).timeout
		GameManager.respawn()
	else:
		# Aplica knockback solo si no estás ya en HURT
		if state != State.HURT:
			state = State.HURT
			anim.modulate = Color(1.0, 0.494, 0.427, 0.635)
			apply_knockback(from_position)


func apply_knockback(from_position: Vector2, knockback_strength: float = 800.0, knockback_time: float = 0.1):
	var dir = (global_position - from_position).normalized()
	velocity = dir * knockback_strength
	var t = get_tree().create_timer(knockback_time)
	t.connect("timeout", Callable(self, "_end_knockback"))

func _end_knockback():
	anim.modulate = Color(1,1,1,1)
	velocity.x = 0
	update_state()
