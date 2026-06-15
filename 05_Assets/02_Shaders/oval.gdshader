shader_type canvas_item;

void fragment() {
	vec2 uv = UV;
	uv = uv * 2. - 1.;
	
	float mask = length(uv) - 1.;
	mask = step(0., mask);
	mask = 1. - mask;
	
	
	
	COLOR.a *= mask;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
