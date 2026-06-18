shader_type canvas_item;

uniform sampler2D noise;
uniform vec2 position;
uniform vec2 size;
uniform vec2 res;

void fragment() {
	vec2 uv = UV;
	uv -= 0.5;
	
	vec2 noise_uv = uv;
	noise_uv += TIME * 0.1;
	noise_uv = fract(noise_uv);
	float noise_mask = texture(noise, noise_uv).r;
	
	//uv += noise_mask * 0.05;
	vec2 pix_pos = uv * res;
	pix_pos -= position;
	
	pix_pos /= res.y / 2.;
	
	float circ_mask = length(pix_pos / (size / res.y)) - 1.;
	circ_mask = smoothstep(0., 0.2 * (res.y / (length(size) + 0.01)), circ_mask);
	
	COLOR.a *= circ_mask;
	
}
