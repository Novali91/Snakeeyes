shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float close_time;
//include start_time (currently it is much past the eye close time)
float flutter_progress() {
	float x = sin(TIME + (1.5 * PI)) + 2.0 - (1.0/(TIME - close_time));
	if (x < 1.0) {
		x = 1.0;
	}
	return x;
}

float eye_dist(vec2 uv) {
	vec2 uv_to_center = uv - vec2(0.5,0.5);
	uv_to_center.y *= flutter_progress();
	return length(uv_to_center);
}

void fragment() {
	bool inside_eye = false;
	if(eye_dist(UV) < 0.5) {
		inside_eye = true;
	}
	if(!inside_eye) {
		COLOR = vec4(0.0,0.0,0.0,1.0);
	} else {
		COLOR = vec4(0.0,0.0,0.0,0.0);
	}
}
