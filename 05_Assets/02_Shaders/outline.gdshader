shader_type canvas_item;

uniform float sprite_alpha: hint_range(0.0, 1.0, 0.1) = 1.;
uniform vec3 color: source_color = vec3(1);
uniform float alpha: hint_range(0.0, 1.0, 0.1) = 1.;
uniform float thickness: hint_range(0.0, 0.2, 0.01) = 0.05;
uniform float x_over_y = 1.0;

const vec2 DIRECTIONS[] = {
	vec2(1, 0),
	vec2(-1, 0),
	vec2(0, 1),
	vec2(0, -1),
	vec2(0.707, 0.707),
	vec2(-0.707, 0.707),
	vec2(0.707, -0.707),
	vec2(-0.707, -0.707)
};

void fragment() {
	float alpha_mask = 0.;
	for (int i = 0; i < 8; i++) {
		vec2 cur_dir = DIRECTIONS[i] / vec2(x_over_y, 1);
		float a = texture(TEXTURE, UV + cur_dir * thickness).a;
		alpha_mask = max(alpha_mask, a);
	}
	
	alpha_mask *= 1. - texture(TEXTURE, UV).a;
	alpha_mask *= alpha;
	
	COLOR.rgb = mix(COLOR.rgb, color, alpha_mask);
	COLOR.a = max(COLOR.a, alpha_mask) * sprite_alpha;
}
