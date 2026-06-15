shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float close_time;
uniform float start_time;
uniform float fade_time;
uniform float flutter_speed;
uniform float fall_dist;
uniform float awake_time;

uniform float time_test;

//include start_time (currently it is much past the eye close time)
float flutter_progress(float time_since_start) {
	float x = (sin(time_since_start * flutter_speed) + 2.0 - (1.0/(time_since_start - close_time))) * ((2.0 * atan(time_since_start) / (2.0 * PI)) + 0.5);
	return x;
}

float eye_dist(vec2 uv, float time_since_start) {
	vec2 uv_to_center = uv - vec2(0.5,0.5);
	uv_to_center.y *= flutter_progress(time_since_start);
	return length(uv_to_center) - 0.01;
}

float fade_out_amount(float time_since_start) {
	return 1.0 - clamp((fade_time - time_since_start) / fade_time,0,1);
}

float awake_amount(float time_since_start) {
	return 1.0 - pow(clamp((awake_time - time_since_start) / (awake_time - close_time),0,1),0.2);
}

vec2 falling_uv(vec2 uv, float time_since_start) {
	if (time_since_start > close_time) {
		return uv;
	}
	return vec2(uv.x,uv.y + fall_dist * pow(max(time_since_start/close_time,0.0),2.0));
}

void fragment() {
	float time_since_start = TIME - start_time;
	//float time_since_start = time_test;
	float feather_amount = time_since_start / 5.;
	
	vec2 uv = UV * 2. - 1.;
	uv *= (1. + time_since_start / close_time * 0.95);
	uv = uv * 0.5 + 0.5;
	
	vec4 screen_color = texture(screen_texture, falling_uv(UV,time_since_start));
	
	if (time_since_start < close_time) {
		
		float eye_mask = eye_dist(uv, time_since_start);
		eye_mask = smoothstep(0.5 - feather_amount, .5 + feather_amount, eye_mask);
		COLOR = mix(vec4(0,0,0,1),screen_color, 1. - eye_mask * fade_out_amount(time_since_start));
		
		
	} else {
		COLOR = mix(vec4(0,0,0,1), screen_color, awake_amount(time_since_start - 0.5));
	}
}
