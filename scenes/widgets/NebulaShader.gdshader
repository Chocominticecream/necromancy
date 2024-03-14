shader_type canvas_item;

//noise texture
uniform sampler2D noise_texture: repeat_enable, filter_nearest;
//fog desnity
uniform float density: hint_range(0.0, 1.0) = 0.25;

uniform vec2 speed = vec2(0.02, 0.01);

void fragment() {
    vec2 uv = UV + speed * TIME;
    
    //smaple noise texture
    float noise = texture(noise_texture, uv).r;
    //convert noise from (0.0, 1.0 ) range to  (-1.0,-1.0)
    float fog = clamp(noise * 2.0 -1.0, 0.0, 1.0);
    //apply fog
    COLOR.a *= fog * density;
	// Called for every pixel the material is visible on.
}

