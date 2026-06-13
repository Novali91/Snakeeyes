shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float close_time;
uniform float start_time;
uniform float fade_time;
uniform float flutter_speed;
uniform float fall_dist;
uniform float awake_time;
//include start_time (currently it is much past the eye close time)
float flutter_progress(float time_since_start) {
	float x = (sin(time_since_start * flutter_speed) + 2.0 - (1.0/(time_since_start - close_time))) * ((2.0 * atan(time_since_start) / (2.0 * PI)) + 0.5);
	return x;
}

float eye_dist(vec2 uv, float time_since_start) {
	vec2 uv_to_center = uv - vec2(0.5,0.5);
	uv_to_center.y *= flutter_progress(time_since_start);
	return length(uv_to_center);
}

float fade_out_amount(float time_since_start) {
	return 1.0 - clamp((fade_time - time_since_start) / fade_time,0,1);
}

float awake_amount(float time_since_start) {
	return 1.0 - pow(clamp((awake_time - time_since_start) / (awake_time - close_time),0,1),0.1);
}

vec2 falling_uv(vec2 uv, float time_since_start) {
	if (time_since_start > close_time) {
		return uv;
	}
	return vec2(uv.x,uv.y + fall_dist * pow(max(time_since_start/close_time,0.0),2.0));
}

void fragment() {
	float time_since_start = TIME - start_time;
	vec4 screenCol = texture(SCREEN_TEXTURE,falling_uv(UV,time_since_start));
	if (time_since_start < close_time) {
		bool inside_eye = false;
		if(eye_dist(UV, time_since_start) < 0.5) {
			inside_eye = true;
		}
		if(!inside_eye) {
			COLOR = mix(screenCol,vec4(0.0,0.0,0.0,1.0),fade_out_amount(time_since_start));
		} else {
			COLOR = screenCol;
		}
	} else {
		COLOR = mix(vec4(0.0,0.0,0.0,1.0),screenCol,awake_amount(time_since_start));
	}
}
