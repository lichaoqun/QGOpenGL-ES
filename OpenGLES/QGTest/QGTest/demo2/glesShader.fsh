//
//  ViewController.m
//  LearnOpenGLESWithGPUImage
//
//  Created by loyinglin on 16/5/10.
//  Copyright © 2016年 loyinglin. All rights reserved.
//

varying highp vec2 texCoordVarying;
precision mediump float;

uniform sampler2D SamplerY;
uniform sampler2D SamplerUV;
uniform mat3 colorConversionMatrix;

void main()
{
    highp vec2 pLeft;
    highp vec2 pRight;
    mediump vec3 yuv;
    lowp vec3 rgb;
    lowp vec3 rgbNew;
    highp float alpha;
    
    pLeft = vec2(texCoordVarying.x/2.0,texCoordVarying.y);
    pRight = vec2(texCoordVarying.x/2.0+0.5,texCoordVarying.y);
    alpha = pLeft.g;

    yuv.x = (texture2D(SamplerY, pRight).r);// - (16.0/255.0));
    yuv.yz = (texture2D(SamplerUV, pRight).ra - vec2(0.5, 0.5));
    rgb = colorConversionMatrix * yuv;
    
    gl_FragColor = vec4(rgb, alpha);
}
