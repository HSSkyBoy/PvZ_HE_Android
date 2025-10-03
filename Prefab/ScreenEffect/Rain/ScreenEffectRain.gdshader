shader_type canvas_item;

uniform sampler2D rainTexture : repeat_enable;
uniform vec2 effectSize = vec2( 1080 , 600 ) ;
uniform float timer = 0.0 ;

void fragment() {
	vec2 _textureSize = vec2( textureSize( rainTexture , 0 ) ) ;
	COLOR = texture( rainTexture , effectSize / ( _textureSize * 1.5 ) * UV + vec2( timer / 3.0 , -timer ) * 5.0 ) ;
}
