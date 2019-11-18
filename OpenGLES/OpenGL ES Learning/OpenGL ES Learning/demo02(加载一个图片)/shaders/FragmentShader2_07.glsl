precision highp float;
varying vec2 varyTextCoord;
uniform sampler2D colorMap;

void main(void){
    vec2 center = vec2(0.5, 0.5);
    vec3 color = texture2D(colorMap, varyTextCoord).rgb;
    vec2 newTextCoord = vec2(varyTextCoord);
    vec3 grayVec = vec3(0.3, 0.59, 0.11);
    float y = varyTextCoord.y;
    const float scale = 1.2;
    
    // - y值在 0 - 1/3 位置 和 2/3 - 1 的位置 设置位置黑白色
    if (y < 1.0 / 3.0 || y > 2.0 / 3.0) {
        
        // - 中心对称 放大 1.2 倍
        newTextCoord -= center;
        newTextCoord = newTextCoord / scale;
        newTextCoord += center;
        
        // - 取色值并且设置为灰色
        color = texture2D(colorMap, newTextCoord).rgb;
        float gray = dot(color, grayVec);
        color = vec3(gray, gray, gray);
    }
    gl_FragColor = vec4(color, 1.0);
}
