precision highp float;
varying vec2 varyTextCoord;
uniform sampler2D colorMap;

void main() {
    float x = varyTextCoord.x;
    if (varyTextCoord.x > 0.5) {
        x = varyTextCoord.x - 0.5;
    }
    
    float y = varyTextCoord.y;
    if (varyTextCoord.y > 0.5) {
        y = varyTextCoord.y - 0.5;
    }
    
    vec2 newTextCoord = vec2(x * 2.0, y * 2.0);
    gl_FragColor = texture2D(colorMap, newTextCoord);
}


