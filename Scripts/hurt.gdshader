shader_type canvas_item;

uniform bool flash_active = false;
uniform float flash_frequency : hint_range(0.1, 30.0) = 0.6;
uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float flash_amount = 0.0;

    if (flash_active) {
        flash_amount = abs(sin(TIME * flash_frequency * TAU));
    }

    vec3 mixed = mix(tex_color.rgb, flash_color.rgb, flash_amount);
    COLOR = vec4(mixed, tex_color.a);
}
