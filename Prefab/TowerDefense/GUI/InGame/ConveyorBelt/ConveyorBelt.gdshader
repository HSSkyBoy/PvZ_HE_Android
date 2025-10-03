shader_type canvas_item;
uniform float _length = 600.0 ;
uniform float speed = 0.1 ;
uniform float time = 0.0 ;
void fragment() {
	COLOR = texture( TEXTURE , vec2( mod( ( UV.x + time * speed ) * ( _length / 503.0 ) , 0.99 )  , UV.y ) ) ;
}