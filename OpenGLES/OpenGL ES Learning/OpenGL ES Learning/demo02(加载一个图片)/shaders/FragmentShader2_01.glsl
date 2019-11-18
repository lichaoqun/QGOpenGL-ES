precision highp float;
varying vec2 varyTextCoord;
uniform sampler2D colorMap;

void main() {
    float y = varyTextCoord.y + 0.25;
    if (varyTextCoord.y > 0.5) {
        y = varyTextCoord.y - 0.25;
    }
    gl_FragColor = texture2D(colorMap, vec2(varyTextCoord.x, y));
}
