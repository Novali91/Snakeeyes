shader_type canvas_item;

uniform float strength: hint_range(0.0, 1.0, 0.1) = 0;

void fragment() {
	vec3 col = texture(TEXTURE, UV).rgb;
	float val = (col.r + col.g + col.b) / 3.;
	COLOR.rgb = mix(COLOR.rgb, vec3(val), strength);
}
