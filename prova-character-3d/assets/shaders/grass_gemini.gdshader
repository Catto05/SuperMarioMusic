shader_type spatial;
// Disabilitiamo il culling: l'erba deve vedersi da entrambi i lati
render_mode cull_disabled, depth_prepass_alpha;

// --- GRUPPO: ASPETTO ---
// La texture che definisce la forma dei fili
uniform sampler2D grass_pattern : filter_linear_mipmap, repeat_enable;
// Colore alla base dell'erba (più scuro/terroso)
uniform vec4 color_base : source_color = vec4(0.05, 0.2, 0.01, 1.0);
// Colore sulla punta dell'erba (più chiaro/vivo)
uniform vec4 color_tip : source_color = vec4(0.2, 0.6, 0.1, 1.0);
// Dove "tagliare" la texture. Gioca con questo valore per fili più o meno spessi.
uniform float cut_threshold : hint_range(0.0, 1.0) = 0.5;

// --- GRUPPO: VENTO ---
uniform sampler2D wind_noise : filter_linear_mipmap, repeat_enable;
uniform float wind_speed = 1.0;
uniform float wind_strength = 0.2;
// Scala della texture del pattern dell'erba (più alto = fili più piccoli)
uniform vec2 pattern_scale = vec2(10.0, 10.0);


void vertex() {
	// --- VENTO SEMPLICE NEL VERTEX ---
	// Campioniamo una texture di rumore che scorre nel tempo
	vec2 wind_uv = UV * 0.1 + vec2(TIME * wind_speed * 0.1, 0.0);
	float wind_val = texture(wind_noise, wind_uv).r;

	// Spostiamo i vertici leggermente in base al vento.
	// Usiamo la posizione del vertice stesso per creare variazione locale.
	VERTEX.x += sin(TIME * wind_speed + VERTEX.z * 2.0) * wind_strength * wind_val;
	VERTEX.z += cos(TIME * wind_speed + VERTEX.x * 2.0) * wind_strength * wind_val;
	// Un leggerissimo movimento verticale per dare "respiro"
	VERTEX.y += wind_val * wind_strength * 0.05;
}

void fragment() {
	// Scaliamo le UV per ripetere il pattern dell'erba molte volte sul piano
	vec2 scaled_uv = UV * pattern_scale;

	// Campioniamo la texture che definisce la forma
	float pattern_value = texture(grass_pattern, scaled_uv).r;

	// --- IL TAGLIO (ALPHA SCISSOR) ---
	// Se il valore della texture è inferiore alla soglia, il pixel viene cancellato.
	// Questo crea la forma dei fili d'erba.
	ALPHA = pattern_value;
	ALPHA_SCISSOR_THRESHOLD = cut_threshold;

	// --- COLORE ---
	// Usiamo il pattern stesso per mescolare i colori.
	// Le parti "piene" del pattern (i fili) saranno del colore punta, le parti più vuote del colore base.
	// Aggiungiamo un po' di variazione casuale basata sulle UV.
	float random_variation = texture(wind_noise, UV * 0.5).r * 0.2;
	vec3 final_color = mix(color_base.rgb, color_tip.rgb, pattern_value + random_variation);

	ALBEDO = final_color;

	// --- IL TRUCCO DELLE NORMALI (FINTA VERTICALITÀ) ---
	// Qui sta la magia dello stile "Genshin".
	// Invece di usare la normale piatta del piano (che punta in alto, vec3(0,1,0)),
	// diciamo allo shader che la superficie è rugosa e punta un po' in tutte le direzioni.
	// Questo fa sì che la luce colpisca i "fili" laterali, facendoli sembrare 3D.
	NORMAL = normalize(vec3(pattern_value - 0.5, 1.0, pattern_value - 0.5));

	// L'erba non è lucida, è ruvida.
	ROUGHNESS = 0.9;
	SPECULAR = 0.1;
}