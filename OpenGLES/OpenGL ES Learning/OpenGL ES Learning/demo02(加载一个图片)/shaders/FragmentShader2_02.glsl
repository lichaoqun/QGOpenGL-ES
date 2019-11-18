precision highp float;
varying vec2 varyTextCoord;
uniform sampler2D colorMap;

void main() {
    float y = varyTextCoord.y;
    if (y < 1.0 / 3.0) {
        y = varyTextCoord.y + 1.0 / 3.0;
    } else if (y > 2.0 / 3.0) {
        y = varyTextCoord.y - 1.0 / 3.0;
    }
    gl_FragColor = texture2D(colorMap, vec2(varyTextCoord.x, y));
}

