class_name CharmOverlay
extends Node2D

const _MAX_SPEED: float = 500
const _ACC: float = 3000

@onready var _bundle: Area2D = $Bundle
@onready var _tokens_node: Node2D = $Tokens
@onready var _count_label: Label = $Bundle/CountLabel
@onready var _bundle_marker: Marker2D = $BundleMarker

@onready var _token_scene: PackedScene = preload("res://03_VisualInputOutput/02_CharmOverlay/charm_token.tscn")

var _tokens: Array[CharmToken] = []
var _all_tokens: Array[CharmToken] = []

func _ready() -> void:
	_count_label.visible = false
	_bundle.mouse_entered.connect(_bundle_hovered)
	_bundle.mouse_exited.connect(_bundle_unhovered)

func _process(delta: float) -> void:
	var screen_center = get_viewport().get_visible_rect().size / 2.
	var global_center = get_viewport().get_canvas_transform().affine_inverse() * screen_center
	_bundle.global_position = global_center - screen_center + _bundle_marker.position
	
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
				t.queue_free()
				continue
		
		elif not t.spent:
			var dir = t.global_position.direction_to(_bundle.global_position)
			t.vel += dir * _ACC * delta
			
			var dir_to_bundle = t.global_position.direction_to(_bundle.global_position)
			if t.vel.dot(dir_to_bundle) < 0:
				t.vel = t.vel.normalized() * min(t.vel.length(), _MAX_SPEED)
		
		else:
			t.spent_timer -= delta
		
		if not t.spent or t.spent_timer <= 0:
			t.global_position += t.vel * delta

func gain_charm(val: int, pos: Vector2) -> void:
	for i in val:
		var new_token: CharmToken = _token_scene.instantiate()
		new_token.global_position = pos
		new_token.wait_timer = i * 0.2
		if i > 0:
			new_token.visible = false
		
		_tokens.push_back(new_token)
		_all_tokens.push_back(new_token)
		_tokens_node.add_child(new_token)

func spend_charm(val: int, pos: Vector2) -> void:
	for i in val:
		var token = _tokens.pop_front()
		token.spent = true
		token.send_to(pos)
		token.vel = Vector2.ZERO
		token.spent_timer = i * 0.2

func clear_charm() -> void:
	for t: CharmToken in _all_tokens:
		t.queue_free()
	
	_tokens = []
	_all_tokens = []

func _bundle_hovered() -> void:
	_count_label.text = str(GS.charm)
	_count_label.visible = true

func _bundle_unhovered() -> void:
	_count_label.visible = false
