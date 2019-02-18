attribute vec3 position;
attribute vec2 textCoordinate;
uniform mat4 projectionMat;
uniform mat4 modelMat;
uniform mat4 viewMat;

varying lowp vec2 varyTextCoord;

void main(){
    varyTextCoord = textCoordinate;
    
    vec4 vPos;
    vPos = projectionMat * viewMat * modelMat * vec4(position, 1.0);
    gl_Position = vPos;
}

