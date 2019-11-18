precision highp float;
varying vec2 varyTextCoord;
uniform sampler2D colorMap;

void main(void){
    vec3 color;
    vec3 grayVec = vec3(0.3, 0.59, 0.11);
    float y = varyTextCoord.y;
    vec2 center = vec2(0.5, 0.5);
    const float scale = 1.2;
    if (y < 1.0 / 3.0) {
        color = texture2D(colorMap, vec2((varyTextCoord.x - center.x) * scale + center.x, (y + (1.0 / 3.0) - center.x) * scale + center.x)).rgb;
        float gray = dot(color, grayVec);
        color = vec3(gray, gray, gray);
    } else if (y > 2.0 / 3.0){
        color = texture2D(colorMap, vec2((varyTextCoord.x - center.x) / scale + center.x, (y - (1.0 / 3.0) - center.x) / scale + center.x)).rgb;
        float gray = dot(color, grayVec);
        color = vec3(gray, gray, gray);
    }else{
        color = texture2D(colorMap, varyTextCoord).rgb;
    }
    gl_FragColor = vec4(color, 1.0);
}
