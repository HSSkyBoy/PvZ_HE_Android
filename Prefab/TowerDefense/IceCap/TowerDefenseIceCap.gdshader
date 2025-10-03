shader_type canvas_item;

uniform float iceLength = 30.0 ;

void fragment() {
	COLOR = texture( TEXTURE , UV * vec2( iceLength / 150.0 , 1.0 ) - vec2( iceLength / 150.0 , 0 ) ) ;
}
