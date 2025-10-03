shader_type canvas_item;

uniform float brightStrength : hint_range(0.0, 0.5, 0.01) = 0.0 ;

void fragment() {
    vec4 c = textureLod(TEXTURE, UV, 0.0);

    COLOR = c ;
	COLOR *= ( 1.0 + brightStrength ) ;
}