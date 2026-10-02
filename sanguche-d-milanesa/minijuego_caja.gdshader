shader_type canvas_item;

uniform vec4 color_borde : source_color = vec4(1.0, 0.8, 0.2, 1.0);
uniform float grosor = 2.5;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    float alpha_arriba = texture(TEXTURE, UV + vec2(0.0, -grosor / 100.0)).a;
    float alpha_abajo = texture(TEXTURE, UV + vec2(0.0, grosor / 100.0)).a;
    float alpha_izquierda = texture(TEXTURE, UV + vec2(-grosor / 100.0, 0.0)).a;
    float alpha_derecha = texture(TEXTURE, UV + vec2(grosor / 100.0, 0.0)).a;

    float borde = max(
        max(alpha_arriba, alpha_abajo),
        max(alpha_izquierda, alpha_derecha)
    );

    if (tex.a > 0.1) {
        COLOR = tex;
    } else if (borde > 0.1) {
        COLOR = color_borde;
    } else {
        COLOR = vec4(0.0);
    }
}
