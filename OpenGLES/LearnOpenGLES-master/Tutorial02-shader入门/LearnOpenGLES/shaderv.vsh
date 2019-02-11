attribute vec4 position;
attribute vec2 textCoordinate;

varying lowp vec2 varyTextCoord;

void main()
{
    varyTextCoord = textCoordinate;
    
    vec4 vPos = position;

    gl_Position = vPos;
}
