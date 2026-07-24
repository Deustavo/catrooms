shader_type spatial;
render_mode blend_mix, cull_back;

uniform vec4 albedo : source_color = vec4(0.32, 0.28, 0.22, 1.0);
uniform vec4 emission_color : source_color = vec4(0.6, 0.15, 0.1, 1.0);
uniform float emission_energy = 0.6;
uniform vec4 border_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform float border_width : hint_range(0.0, 0.5) = 0.08;
uniform bool chasing = false;

// Faz o quad girar sempre de frente para a câmera (billboard completo),
// já que render_mode não oferece essa opção para shaders customizados.
void vertex() {
	MODELVIEW_MATRIX = VIEW_MATRIX
			* mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
}

void fragment() {
	ALBEDO = albedo.rgb;
	EMISSION = emission_color.rgb * emission_energy;
	ROUGHNESS = 1.0;

	if (chasing) {
		vec2 edge_dist = min(UV, vec2(1.0) - UV);
		float edge = min(edge_dist.x, edge_dist.y);
		if (edge < border_width) {
			ALBEDO = border_color.rgb;
			EMISSION = border_color.rgb * 2.0;
		}
	}
}
