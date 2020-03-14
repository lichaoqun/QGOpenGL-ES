varying lowp vec2 varyTextCoord;
uniform sampler2D colorMap1;
uniform sampler2D colorMap2;

void main(void){
    mediump float alpha;
    bool c;
    
    alpha = texture2D(colorMap2, varyTextCoord).a;
    c = alpha > 0.0;
    if (c) {
        gl_FragColor = texture2D(colorMap2, varyTextCoord);
    }else{
        gl_FragColor = texture2D(colorMap1, varyTextCoord);
    }
}


