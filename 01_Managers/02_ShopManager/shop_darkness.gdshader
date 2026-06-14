shader_type canvas_item;

uniform float alpha: hint_range(0.0, 1.0, 0.1) = 1.0;

void fragment() {
	COLOR = vec4(0.0,0.0,0.0,clamp(UV.x*5.0,0.0,1.0)/3.);
	COLOR.a *= alpha;
}
