precision highp float;
varying vec2 varyTextCoord;

uniform sampler2D colorMap1;
uniform sampler2D colorMap2;

uniform float timestamp;


float rand(float n) {
    return fract(sin(n) * 43758.5453123);
}

vec4 jitter(){
    const float PI = 3.1415926;
    
    float maxJitter = 0.06;
    float duration = 0.3;
    float colorROffset = 0.01;
    float colorBOffset = -0.025;
    
    float time = mod(timestamp, duration * 2.0);
    float amplitude = max(sin(time * (PI / duration)), 0.0);
    
    float jitter = rand(varyTextCoord.y) * 2.0 - 1.0; // -1~1
    bool needOffset = abs(jitter) < maxJitter * amplitude;
    
    float textureX = varyTextCoord.x + (needOffset ? jitter : (jitter * amplitude * 0.006));
    vec2 textureCoords = vec2(textureX, varyTextCoord.y);
    
    vec4 mask = texture2D(colorMap1, varyTextCoord);
    vec4 maskR = texture2D(colorMap1, varyTextCoord + vec2(colorROffset * amplitude, 0.0));
    vec4 maskB = texture2D(colorMap1, varyTextCoord + vec2(colorBOffset * amplitude, 0.0));
    
    return vec4(maskR.r, mask.g, maskB.b, mask.a);

}

void main(void){
    
    float offsetX = 0.8;
    float offsetY = 0.2;
//    vec4 textureColor = texture2D(colorMap1, varyTextCoord);
    vec4 textureColor = jitter();

    if (varyTextCoord.x >= offsetX && varyTextCoord.y <= offsetY) {
        vec4 textureColor2 = texture2D(colorMap2, vec2((varyTextCoord.x - offsetX) * 5.0, varyTextCoord.y * 5.0));
        // - mix(x, y, a) 函数  x( 1 - a) + y * a;
        // - dot({x1, y1}, {x2, y2}) 函数 x1 * x2 + y1 * y2
        
        gl_FragColor = vec4(mix(textureColor.rgb, textureColor2.rgb, textureColor2.a), 1.0);
        return;
    }
    gl_FragColor = textureColor;
}             

