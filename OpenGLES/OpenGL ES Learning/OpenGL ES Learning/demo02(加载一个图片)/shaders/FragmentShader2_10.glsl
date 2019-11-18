precision highp float;
varying vec2 varyTextCoord;
uniform sampler2D colorMap;

// - 黑白色
vec3 grayColor(sampler2D colorM, vec2 textCoord){
    float gray = dot(texture2D(colorMap,textCoord).xyz, vec3(0.3, 0.59, 0.11));
    return vec3(gray, gray, gray);
}

// - 缩放
vec2 scaleByPoint(vec2 textCoord, float scale, vec2 center){
    vec2 newTextCoord = textCoord;
    newTextCoord -= center;
    newTextCoord = newTextCoord / scale;
    newTextCoord += center;
    return newTextCoord;
}


// - 马赛克
vec2 scaleByPoint(sampler2D colorM, vec2 textCoord){
    vec2 newTextCoord = textCoord;
    newTextCoord -= center;
    newTextCoord = newTextCoord / scale;
    newTextCoord += center;
    return newTextCoord;
}

void main(void){
    gl_FragColor = texture2D(colorMap, varyTextCoord);
}

