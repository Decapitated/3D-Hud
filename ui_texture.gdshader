shader_type spatial;
render_mode unshaded;

uniform sampler2D ui_texture: source_color;

void fragment() {
	vec4 sample = texture(ui_texture, UV);
	ALBEDO = sample.rgb;
	ALPHA = sample.a;
}
