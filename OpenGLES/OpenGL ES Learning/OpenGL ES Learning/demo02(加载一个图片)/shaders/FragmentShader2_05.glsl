precision highp float;
varying vec2 varyTextCoord;
uniform sampler2D colorMap;

void main() {
    float x = varyTextCoord.x;
    if (x > 1.0 / 3.0 && x < 2.0 / 3.0){
        x = x - 1.0 / 3.0;
    }else if (x > 2.0 / 3.0){
        x = x - 2.0 / 3.0;
    }
    
    float y = varyTextCoord.y;
    if (y > 1.0 / 3.0 && y < 2.0 / 3.0){
        y = y - 1.0 / 3.0;
    }else if (y > 2.0 / 3.0){
        y = y - 2.0 / 3.0;
    }

    gl_FragColor = texture2D(colorMap, vec2(x * 3.0, y * 3.0));
}



