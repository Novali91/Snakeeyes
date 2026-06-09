shader_type canvas_item;

uniform float strength: hint_range(0.0, 1.0, 0.1) = 0;
uniform float alpha: hint_range(0.0, 1.0, 0.1) = 1.;

void fragment() {
	vec3 col = COLOR.rgb;
	float val = (col.r + col.g + col.b) / 3.;
	COLOR.rgb = mix(COLOR.rgb, vec3(val), strength);
	COLOR.a = alpha * COLOR.a;
}
