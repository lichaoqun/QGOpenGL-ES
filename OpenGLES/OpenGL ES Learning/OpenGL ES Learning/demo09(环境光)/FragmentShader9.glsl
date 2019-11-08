precision highp float;
/*
 ambient材质向量定义了在环境光照下这个物体反射的是什么颜色；通常这是和物体颜色相同的颜色。
 diffuse材质向量定义了在漫反射光照下物体的颜色。漫反射颜色被设置为(和环境光照一样)我们需要的物体颜色。
 specular材质向量设置的是物体受到的镜面光照的影响的颜色(或者可能是反射一个物体特定的镜面高光颜色)。
 shininess影响镜面高光的散射/半径。
 
*/
// - 材质
struct Material {
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    float shininess;
};

// - 光
struct Light {
    vec3 position; // - 位置
    vec3 ambient; // - 环境光照
    vec3 diffuse; // - 漫反射光照
    vec3 specular; // - 镜面反射光照
};

varying vec3 FragPos;

// - 法向量
varying vec3 Normal;

uniform vec3 viewPos;
uniform Material material;
uniform Light light;

void main(void) {
    
    // - 环境光
    vec3 ambient = light.ambient * material.ambient;
    
    // - 漫反射光
    vec3 norm = normalize(Normal);
    vec3 lightDir = normalize(light.position - FragPos);
    float diff = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = light.diffuse * (diff * material.diffuse);
    
    // - 镜面光
    vec3 viewDir = normalize(viewPos - FragPos);
    vec3 reflectDir = reflect(-lightDir, norm);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
    vec3 specular = light.specular * (spec * material.specular);
    
    vec3 result = ambient + diffuse + specular;
    gl_FragColor = vec4(result, 1.0);
}
