shader_type canvas_item;

void fragment() {
	vec2 norm_uv = UV * 2. - 1.;
	float circ_mask = length(norm_uv) - 0.1;
	circ_mask = smoothstep(0.3, 1., circ_mask);
	circ_mask = 1. - circ_mask;
	
	COLOR.a = circ_mask;
}
