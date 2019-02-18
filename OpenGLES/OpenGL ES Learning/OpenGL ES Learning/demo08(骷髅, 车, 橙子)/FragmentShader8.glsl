varying lowp vec2 varyTextCoord;
uniform sampler2D colorMap;

void main(void){
    // - 正片叠底的 shader
    gl_FragColor = texture2D(colorMap,varyTextCoord) * (vec4(0.0, 0.3, 0.6, 1.0));
    
    // - 普通的 shader
//    gl_FragColor = texture2D(colorMap, varyTextCoord);
}

