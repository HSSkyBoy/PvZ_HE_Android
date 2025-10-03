shader_type canvas_item;

uniform sampler2D refraction_map;

uniform vec2 refraction_stretch = vec2(1.0, 1.0);
uniform float refraction_strength : hint_range(0.0, 0.1) = 0.02;

uniform float timer = 0.0 ;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

varying vec2 globalposition;
void vertex(){
	globalposition = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment(){
	vec2 uv = globalposition / 512.0;

	vec2 refraction_offset = texture(
		refraction_map,
		vec2(
			mod(uv.x * refraction_stretch.x + timer, 1.0),
			mod(uv.y * refraction_stretch.y + timer, 1.0))).xy;
	refraction_offset -= 0.5;

	vec4 refraction = texture(SCREEN_TEXTURE, SCREEN_UV - refraction_offset * refraction_strength);

	COLOR = refraction;
}