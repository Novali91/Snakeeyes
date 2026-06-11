shader_type canvas_item;

uniform float level;
uniform vec4 main_col;
uniform vec4 secondary_col;
uniform vec4 back_col;
uniform float wave_speed;
uniform float wave_amplitude;
uniform float wave_length;
uniform sampler2D mask;

void vertex() {
}

void fragment() {
	if(texture(mask,UV) == vec4(0.0,1.0,0.0,1.0)) {
		COLOR = vec4(0.0,0.0,0.0,0.0);
	} else {
		float main_wave_height = level + (sin((TIME + (UV.x / wave_length)) * wave_speed) * wave_amplitude);
		float secondary_wave_height = level + (sin((TIME * 0.5 + (UV.x / wave_length * 1.5)) * wave_speed) * wave_amplitude / 2.0);
		if (1.0 - UV.y < main_wave_height) {
			COLOR = main_col;
		} else if (1.0 - UV.y < secondary_wave_height) {
			COLOR = secondary_col;
		} else {
			COLOR = back_col;
		}
	}
}
