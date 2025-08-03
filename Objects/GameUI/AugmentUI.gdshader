shader_type canvas_item;

uniform vec4 shine_color : source_color = vec4(1.0, 1.0, 1.0, 0.5);
uniform float shine_speed : hint_range(0.0, 10.0, 0.1) = 3.5;
uniform float shine_size : hint_range(0.01, 1.0, 0.01) = 0.03;

void fragment() {
    COLOR = texture(TEXTURE, UV);

    // Phase shift constant to create delay between shines
    const float phase_shift = 2.0;

    // First shine effect
    float shine1 = step(1.0 - shine_size * 0.5, 0.5 + 0.5 * sin(UV.x + UV.y * 2.0 + TIME * shine_speed * 1.5));

    // Second shine effect with phase shift
    float shine2 = step(1.0 - shine_size * 0.5, 0.5 + 0.5 * sin(UV.x + UV.y * 2.0 + TIME * shine_speed * 1.5 + phase_shift));

    // Third shine effect with double phase shift
    float shine3 = step(1.0 - shine_size * 0.5, 0.5 + 0.5 * sin(UV.x + UV.y * 2.0 + TIME * shine_speed * 1.5 + phase_shift * 2.0));

    // Combine the shine effects
    float combined_shine = max(shine1, max(shine2, shine3));

    COLOR.rgb = mix(COLOR.rgb, shine_color.rgb, combined_shine * shine_color.a);
}