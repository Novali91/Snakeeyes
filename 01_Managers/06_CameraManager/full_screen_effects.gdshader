shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float fisheye_intensity;
uniform float fisheye_speed;

float bulge_lerp(float x) {
	return pow(2,-pow(((4.0*x)-2.0),2.0));
}

void fragment() {
	vec2 center_to_uv = (UV-0.5)*2.0;
	//vec2 offset_uv = UV - center_to_uv * pow((1.0-length(center_to_uv)),fisheye_intensity);
	vec2 offset_uv = UV - normalize(center_to_uv) * bulge_lerp(length(center_to_uv)) * fisheye_intensity * sin(TIME * fisheye_speed);
	//vec2 center_to_uv = UV;
	//vec2 distorted_center_to_uv = fisheye_intensity * vec2(center_to_uv.x * abs(center_to_uv.x), center_to_uv.y * abs(center_to_uv.y));
	//vec2 offset_uv = UV + distorted_center_to_uv;
	//vec2 offset_uv = UV - uv_to_center * fisheye_intensity;
	//COLOR = vec4(offset_uv.x,offset_uv.y,0.0,1.0);
	//COLOR = vec4(UV.x,UV.y,0.0,1.0);
	//COLOR = vec4(0.0,0.0,0.0,0.0);
	//COLOR = vec4(1.0,1.0,1.0,1.0) * length(offset_uv);
	//COLOR = vec4(center_to_uv.x,center_to_uv.y,0.0,1.0);
	//COLOR = vec4(UV.x,UV.y,0.0,1.0);
	//COLOR = vec4(offset_uv.x,offset_uv.y,0.0,1.0);
	COLOR = texture(SCREEN_TEXTURE,offset_uv);
}
