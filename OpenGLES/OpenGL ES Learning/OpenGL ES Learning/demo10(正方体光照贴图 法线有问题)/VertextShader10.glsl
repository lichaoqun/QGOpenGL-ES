attribute vec3 position;
attribute vec3 normal;
attribute vec2 textCoord;

uniform mat4 projectionMat;
uniform mat4 modelMat;
uniform mat4 viewMat;
uniform mat4 normalMat;

varying lowp vec3 FragPos;
varying lowp vec3 Normal;
varying lowp vec2 varyTextCoord;

void main(){
    Normal = mat3(modelMat) * normal;
    FragPos = vec3(modelMat * vec4(position, 1.0));
    varyTextCoord = textCoord;
    
    vec4 vPos;
    vPos = projectionMat * viewMat * vec4(FragPos, 1.0);
    gl_Position = vPos;
}
