shader_type canvas_item;

uniform sampler2D noise;

uniform float strength = 0.05;
uniform float speed = 0.1;
uniform vec4 color: source_color = vec4(1);

void fragment() {
	vec2 uv = UV;
	uv = uv * 2. - 1.;
	
	vec2 noise_uv = UV;
	noise_uv += TIME * speed;
	noise_uv = fract(noise_uv);
	
	float offset = texture(noise, noise_uv).r - 0.5;
	uv += offset * strength;
	
	uv = uv * 0.5 + 0.5;
	uv = fract(uv);
	
	COLOR = texture(TEXTURE, uv) * color;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
