precision highp float;
varying vec2 varyTextCoord;
uniform sampler2D colorMap;

void main(void){
    gl_FragColor = texture2D(colorMap, varyTextCoord);
}
