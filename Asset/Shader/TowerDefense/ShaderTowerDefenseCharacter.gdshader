shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float brightStrength : hint_range(0.0, 0.5, 0.001) = 0.0 ;
uniform float whiteStrength : hint_range(0.0, 1.0, 0.001) = 0.0 ;
uniform float surfaceUpPos : hint_range(0.0, 1.0, 0.001) = 0.0 ;
uniform float surfaceDownPos : hint_range(0.0, 1.0, 0.001) = 1.0 ;
uniform float surfacePos : hint_range(0.0, 1.0, 0.001) = 1.0 ;

const vec4 iceSpeedDownColor = vec4( 0.2 , 0.35 , 1.0 , 1.0 ) ;
const vec4 charmColor = vec4( 0.83 , 0.34 , 0.81 , 1.0 ) ;
const vec4 redHeatColor = vec4( 0.78 , 0.0 , 0.0 , 1.0 ) ;
uniform bool ash = false ;
uniform bool iceSpeedDown = false ;
uniform bool cover = false ;
uniform bool hypnoses = false ;
uniform bool imitater = false ;
uniform bool redHeat = false ;

void fragment() {
    vec4 c = textureLod( screen_texture , SCREEN_UV - vec2( 0.0 , 1.0 - surfacePos ) , 0.0 ) ;
	if ( SCREEN_UV.y < 1.0 - surfacePos ){
		discard ;
	}
	if ( UV.y < surfaceUpPos ){
		discard ;
	}
	if ( UV.y > surfaceDownPos ){
		discard ;
	}

    if ( c.a > 0.0001 ) {
        c.rgb /= c.a ;
		c += whiteStrength ;
		c *= ( 1.0 + brightStrength ) ;
    }

    COLOR *= c ;
	if ( imitater ){
		float lumi = ( COLOR.r + COLOR.g + COLOR.b ) / 3.0 ;
		COLOR.rgb = vec3( lumi ) ;
	}
	if ( iceSpeedDown ){
		COLOR *= iceSpeedDownColor ;
	}
	if ( hypnoses ){
		COLOR *= charmColor ;
	}
	if ( redHeat ){
		COLOR *= redHeatColor ;
	}
	if ( ash ){
		COLOR *= vec4( 0.0 , 0.0 , 0.0 , 1.0 ) ;
	}
	if ( cover ){
		float coverColor = 0.75 + sin( TIME * 5.0 ) * 0.25 ;
		COLOR *= vec4( coverColor , coverColor , coverColor , 1.0 ) ;
	}

}
