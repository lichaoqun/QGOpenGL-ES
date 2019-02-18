precision highp float;

struct Material {
    sampler2D colorMap1;
    sampler2D colorMap2;
    float shininess;
};

struct Light {
    vec3 position;

    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};

varying lowp vec3 FragPos;
varying lowp vec3 Normal;
varying lowp vec2 varyTextCoord;

uniform vec3 viewPos;
uniform Material material;
uniform Light light;

void main()
{
    // ambient
    vec3 ambient = light.ambient * texture2D(material.colorMap1,varyTextCoord).rbg;

    // diffuse
    vec3 norm = normalize(Normal);
    vec3 lightDir = normalize(light.position - FragPos);
    float diff = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = light.diffuse * (diff * texture2D(material.colorMap1,varyTextCoord).rbg);

    // specular
    vec3 viewDir = normalize(viewPos - FragPos);
    vec3 reflectDir = reflect(-lightDir, norm);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
    vec3 specular = light.specular * (spec * texture2D(material.colorMap2,varyTextCoord).rbg);

    vec3 result = ambient + diffuse + specular;
    gl_FragColor = vec4(result, 1.0);
}
