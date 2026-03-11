shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

// --- UNIFORMS (SETTINGS) ---

// Gruppo: Impostazioni Triplanar (Da Shader 1)
group_uniforms Triplanar_Settings;
uniform float uv1_blend_sharpness : hint_range(0.0, 150.0, 0.001) = 1.0;
uniform vec3 uv1_scale = vec3(0.5, 0.5, 0.5); // Regola questo per ingrandire/rimpicciolire la griglia
uniform vec3 uv1_offset;

// Gruppo: Impostazioni Procedurali (Da Shader 2)
group_uniforms Procedural_Pattern;
uniform float grid_size : hint_range(1.0, 100.0) = 15.0;
uniform float tile_speed : hint_range(0.1, 10.0) = 2.0;
uniform vec4 color1 : source_color = vec4(0.62, 0.14, 0.0, 1.0);
uniform vec4 color2 : source_color = vec4(0.93, 0.54, 1.0, 1.0);
uniform vec4 color3 : source_color = vec4(0.36, 0.29, 0.41, 1.0);
uniform float emission_strength : hint_range(0.0, 5.0) = 1.0;

// Gruppo: Materiale Fisico (Ruvidità/Metallico)
group_uniforms PBR_Properties;
uniform float roughness : hint_range(0.0, 1.0) = 0.5;
uniform float metallic : hint_range(0.0, 1.0) = 0.0;
uniform float specular : hint_range(0.0, 1.0) = 0.5;

// Variabili passate dal Vertex al Fragment shader
varying vec3 uv1_triplanar_pos;
varying vec3 uv1_power_normal;

const float TWO_PI = 6.283185307179586;

// --- FUNZIONI AUSILIARIE (MATEMATICA) ---

float random (vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

vec2 grid(in vec2 uv, in float size) {
    return fract(uv * size);
}

vec3 getColor(in vec2 tile_coord) {
    float tile_mod = mod(tile_coord.x + tile_coord.y, 3.0);
    if (tile_mod == 1.0) return color1.rgb;
    if (tile_mod == 2.0) return color2.rgb;
    return color3.rgb;
}

// --- LOGICA GENERAZIONE PIASTRELLE ---
// Questa funzione calcola il colore di un singolo punto basandosi su una coordinata UV
vec3 get_procedural_color(vec2 uv_coords) {
    vec2 frag = grid(uv_coords, grid_size);
    vec2 tile_coord = floor(uv_coords * grid_size);

    vec3 color = getColor(tile_coord);
    vec2 black = smoothstep(1.08, 0.95, cos(frag * TWO_PI));

    // Calcolo del pattern (bordi neri)
    color *= black.x * black.y * smoothstep(1.0, 0.0, length(fract(frag) - 0.5));

    // Animazione temporale
    float animation_wave = cos(random(tile_coord) * TIME * tile_speed);
    float brightness = 0.5 + 0.5 * animation_wave; 

    return color * brightness;
}

// --- VERTEX SHADER (PREPARAZIONE TRIPLANAR) ---
void vertex() {
    vec3 normal = NORMAL;
    TANGENT = vec3(0.0, 0.0, -1.0) * abs(normal.x);
    TANGENT += vec3(1.0, 0.0, 0.0) * abs(normal.y);
    TANGENT += vec3(1.0, 0.0, 0.0) * abs(normal.z);
    TANGENT = normalize(TANGENT);
    BINORMAL = vec3(0.0, 1.0, 0.0) * abs(normal.x);
    BINORMAL += vec3(0.0, 0.0, -1.0) * abs(normal.y);
    BINORMAL += vec3(0.0, 1.0, 0.0) * abs(normal.z);
    BINORMAL = normalize(BINORMAL);

    // Calcolo pesi e posizione Triplanar
    uv1_power_normal = pow(abs(NORMAL), vec3(uv1_blend_sharpness));
    uv1_triplanar_pos = VERTEX * uv1_scale + uv1_offset;
    uv1_power_normal /= dot(uv1_power_normal, vec3(1.0));
    uv1_triplanar_pos *= vec3(1.0, -1.0, 1.0);
}

// --- FUNZIONE CHE FONDE I 3 PIANI ---
vec3 triplanar_procedural(vec3 p_weights, vec3 p_triplanar_pos) {
    vec3 samp = vec3(0.0);
    
    // Proiezione dall'alto (Y) - Piano Pavimento principale
    samp += get_procedural_color(p_triplanar_pos.xz) * p_weights.y;
    
    // Proiezione Frontale (Z)
    samp += get_procedural_color(p_triplanar_pos.xy) * p_weights.z;
    
    // Proiezione Laterale (X)
    samp += get_procedural_color(p_triplanar_pos.zy * vec2(-1.0, 1.0)) * p_weights.x;
    
    return samp;
}

// --- FRAGMENT SHADER ---
void fragment() {
    // Calcoliamo il colore finale fondendo le 3 proiezioni
    vec3 final_albedo = triplanar_procedural(uv1_power_normal, uv1_triplanar_pos);

    ALBEDO = final_albedo;
    METALLIC = metallic;
    ROUGHNESS = roughness;
    SPECULAR = specular;
    
    // Aggiungiamo l'emissione
    EMISSION = final_albedo * emission_strength;
}