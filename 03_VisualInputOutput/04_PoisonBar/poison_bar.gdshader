shader_type canvas_item;

uniform float level;
uniform float max_height;
uniform vec4 color;
uniform float wave_speed;
uniform float wave_amplitude;
uniform float wave_length;

void vertex() {
	float average_height = (VERTEX.y * level * -1.0) + max_height;
	float wave_height = (sin((TIME + (VERTEX.x * wave_length)) * wave_speed) * VERTEX.y * wave_amplitude);
	VERTEX.y = average_height + wave_height;
}

void fragment() {
	COLOR = color;
}
