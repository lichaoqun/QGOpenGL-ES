attribute vec3 position;
attribute vec3 normal;

uniform mat4 projectionMat;
uniform mat4 modelMat;
uniform mat4 viewMat;
uniform mat4 normalMat;

varying vec3 FragPos;
varying vec3 Normal;

void main(){
//    Normal = mat3(transpose(inverse(modelMat))) * normal;
    Normal = mat3(normalMat) * normal;
    FragPos = vec3(modelMat * vec4(position, 1.0));

    vec4 vPos;
    vPos = projectionMat * viewMat * vec4(FragPos, 1.0);
    gl_Position = vPos;
}

