varying vec2 texCoordVarying;
uniform sampler2D inputImageTexture;

void main()
{
    vec2 pLeft = vec2(texCoordVarying.x/2.0,texCoordVarying.y);
    vec2 pRight = vec2(texCoordVarying.x/2.0+0.5,texCoordVarying.y);
    
    float alpha = texture2D(inputImageTexture, pLeft).r;
    vec3 color = texture2D(inputImageTexture, pRight).rgb;
    
    gl_FragColor = vec4(color,alpha);
    }
