attribute vec3 position;
attribute vec3 normal;

uniform mat4 projectionMat;
uniform mat4 modelMat;
uniform mat4 viewMat;
uniform mat4 inverseTransposeModelMat;

varying vec3 FragPos;
varying vec3 Normal;

void main(){
    // -将法向量转换为世界坐标空间
    Normal = mat3(inverseTransposeModelMat) * normal;
    
    // - 计算片段位置 (需要在世界空间中计算)
    FragPos = vec3(modelMat * vec4(position, 1.0));

    vec4 vPos;
    vPos = projectionMat * viewMat * modelMat * vec4(position, 1.0);
    gl_Position = vPos;
}

