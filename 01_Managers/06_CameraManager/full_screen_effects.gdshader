shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float fisheye_intensity;
uniform float fisheye_speed;

float bulge_lerp(float x) {
	return pow(2,-pow(((4.0*x)-2.0),2.0));
}

void fragment() {
	vec2 center_to_uv = (UV-0.5)*2.0;
	vec2 offset_uv = UV - normalize(center_to_uv) * bulge_lerp(length(center_to_uv)) * fisheye_intensity * sin(TIME * fisheye_speed);
	COLOR = texture(SCREEN_TEXTURE,offset_uv);
}
