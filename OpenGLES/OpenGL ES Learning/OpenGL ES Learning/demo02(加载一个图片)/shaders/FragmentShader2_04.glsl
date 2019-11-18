precision highp float;
varying vec2 varyTextCoord;
uniform sampler2D colorMap;

void main() {
    vec2 newTextCoord = vec2(varyTextCoord);
    if (varyTextCoord.x < 1.0 / 3.0) {
        newTextCoord.x = varyTextCoord.x + 1.0 / 3.0;
    }else if (varyTextCoord.x > 2.0 / 3.0){
        newTextCoord.x = varyTextCoord.x - 1.0 / 3.0;
    }
    
    if (varyTextCoord.y < 1.0 / 3.0) {
        newTextCoord.y = varyTextCoord.y + 1.0 / 3.0;
    }else if (varyTextCoord.y > 2.0 / 3.0){
        newTextCoord.y = varyTextCoord.y - 1.0 / 3.0;
    }
    gl_FragColor = texture2D(colorMap, newTextCoord);
}


