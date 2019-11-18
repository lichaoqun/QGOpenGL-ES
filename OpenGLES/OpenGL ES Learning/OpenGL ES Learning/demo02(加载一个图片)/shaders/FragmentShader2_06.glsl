precision highp float;
varying vec2 varyTextCoord;
uniform sampler2D colorMap;

void main(void){
    vec4 color = texture2D(colorMap, varyTextCoord);
    // - 向量点乘, 和下边的写法相同
    float gray = dot(color.rgb, vec3(0.3, 0.59, 0.11));
//    float gray = 0.3 * color.r + 0.59 * color.g + 0.11 * color.b;

    gl_FragColor = vec4(gray, gray, gray,  1.0);
}
