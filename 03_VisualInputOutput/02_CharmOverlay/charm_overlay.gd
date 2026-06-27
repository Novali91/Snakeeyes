class_name CharmOverlay
extends Node2D

const _MAX_SPEED: float = 500
const _ACC: float = 2000
const _MAX_TOKENS_SHOWN: int = 50
const _TOTAL_SPAWN_TIME: float = 0.75

@onready var _bundle: Area2D = $Bundle
@onready var _tokens_node: Node2D = $Tokens
@onready var _count_label: Label = $Bundle/CountLabel
@onready var _bundle_marker: Marker2D = $BundleMarker
@onready var _afters_node: Node2D = $Afters

@onready var _token_scene: PackedScene = preload("res://03_VisualInputOutput/02_CharmOverlay/charm_token.tscn")
@onready var _token_after_scene: PackedScene = preload("res://03_VisualInputOutput/02_CharmOverlay/charm_token_after.tscn")

var _tokens: Array[CharmToken] = []
var _all_tokens: Array[CharmToken] = []
var _reveal_timer: float = 0
var _current_charm_count: int = 0

func _process(delta: float) -> void:
	var screen_center = get_viewport().get_visible_rect().size / 2.
	var global_center = get_viewport().get_canvas_transform().affine_inverse() * screen_center
	_bundle.global_position = global_center - screen_center + _bundle_marker.position
	
	_reveal_timer -= delta
	
	for t: CharmToken in _all_tokens:
		if t.wait_timer > 0:
			t.wait_timer -= delta
			
			if t.wait_timer <= 0:
				t.visible = true
			
			else:
				continue
		
		if t.spent and t.spent_timer <= 0:
			t.vel += t.spent_dir * _ACC * delta
			t.spent_dist -= t.vel.length() * delta
			if t.spent_dist <= 0:
				_all_tokens.erase(t)
				t.die()
				GS.sound_manager.play_charm()
				continue
		
		elif not t.spent:
			var dir = t.global_position.direction_to(_bundle.global_position)
			t.vel += dir * _ACC * delta
			
			var dir_to_bundle = t.global_position.direction_to(_bundle.global_position)
			if t.vel.dot(dir_to_bundle) < 0 and t.vel.length() > _MAX_SPEED:
				t.vel = t.vel.normalized() * t.vel.length() / (1. + delta * 10.)
				if !t.has_reached_bundle:
					t.has_reached_bundle = true
					GS.sound_manager.play_charm()
			
			var delete_fake = t.vel.dot(dir_to_bundle) < 0 and t.is_fake
			if t.global_position.distance_to(_bundle.global_position) < 200 and delete_fake:
				_all_tokens.erase(t)
				t.die()
		
		else:
			t.spent_timer -= delta
		
		if not t.spent or t.spent_timer <= 0:
			t.global_position += t.vel * delta
			
			if t.after_timer <= 0:
				t.after_timer = 0.05
				var new_after: Sprite2D = _token_after_scene.instantiate()
				new_after.global_position = t.global_position
				_afters_node.add_child(new_after)
			t.after_timer -= delta

func gain_charm(val: int, pos: Vector2) -> void:
	if val == 0: return
	
	var is_neg = val < 0
	_reveal_timer = 1
	
	_count_label.text = GS.format_number(GS.get_charm())
	
	var abs_val = abs(val)
	
	var fake_count = 0
	
	var wait_time = _TOTAL_SPAWN_TIME / (abs_val)
	if abs_val > _MAX_TOKENS_SHOWN:
		wait_time = _TOTAL_SPAWN_TIME / (_MAX_TOKENS_SHOWN)
	
	for i in abs_val:
		
		var fake = false
		var same_dir = (_current_charm_count > 0 and not is_neg) or (_current_charm_count < 0 and is_neg)
		if same_dir and ((_current_charm_count >= _MAX_TOKENS_SHOWN) or (_current_charm_count <= -_MAX_TOKENS_SHOWN)):
			fake = true
			fake_count += 1
		elif not same_dir and ((_current_charm_count > _MAX_TOKENS_SHOWN) or (_current_charm_count < -_MAX_TOKENS_SHOWN)):
			fake = true
			fake_count += 1
		
		if fake and fake_count > _MAX_TOKENS_SHOWN: 
			_current_charm_count += -1 if is_neg else 1
			continue
		
		var new_token: CharmToken = _token_scene.instantiate()
		new_token.evil_collided.connect(_evil_collision)
		new_token.evil = is_neg
		new_token.global_position = pos + Vector2(randf_range(0, 30), 0).rotated(randf() * TAU)
		new_token.wait_timer = i * wait_time
		new_token.after_timer = randf_range(0., 0.05)
		new_token.is_fake = fake
		if i > 0:
			new_token.visible = false
		
		if not new_token.is_fake:
			_tokens.push_back(new_token)
		
		_current_charm_count += -1 if is_neg else 1
		
		_all_tokens.push_back(new_token)
		_tokens_node.add_child(new_token)

func spend_charm(val: int, pos: Vector2) -> void:
	if val == 0: return
	
	var fake_count = 0
	
	_reveal_timer = 1
	_count_label.text = GS.format_number(GS.get_charm())
	
	var wait_time = _TOTAL_SPAWN_TIME / (val)
	if val > _MAX_TOKENS_SHOWN:
		wait_time = _TOTAL_SPAWN_TIME / (_MAX_TOKENS_SHOWN)
	
	for i in val:
		_current_charm_count -= 1
		
		var spent_token: CharmToken
		
		if _current_charm_count < _MAX_TOKENS_SHOWN:
			spent_token = _tokens.pop_front()
		
		else:
			if fake_count > _MAX_TOKENS_SHOWN: continue
			
			spent_token = _token_scene.instantiate()
			spent_token.global_position = _bundle.global_position
			_all_tokens.push_back(spent_token)
			_tokens_node.add_child(spent_token)
			
			fake_count += 1
		
		spent_token.spent = true
		spent_token.send_to(pos + Vector2(randf_range(0, 30), 0).rotated(randf() * TAU))
		spent_token.vel = Vector2.ZERO
		spent_token.spent_timer = i * wait_time

func clear_charm() -> void:
	for t: CharmToken in _tokens:
		_all_tokens.erase(t)
		t.die()
	
	_tokens = []
	_current_charm_count = 0
	
	_count_label.text = GS.format_number(GS.get_charm())

func _evil_collision(me: CharmToken, other: CharmToken) -> void:
	if me.deleted or other.deleted: return
	if me.is_fake or other.is_fake: return
	
	me.deleted = true
	other.deleted = true
	
	_tokens.erase(me)
	_tokens.erase(other)
	_all_tokens.erase(me)
	_all_tokens.erase(other)
	me.die()
	other.die()
