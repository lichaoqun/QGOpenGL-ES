
//
//  QGGLView.m
//  LearnOpenGLES
//
//  Created by 李超群 on 2019/1/24.
//  Copyright © 2019 loyinglin. All rights reserved.
//

#import "QGGLView.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@implementation QGGLView{
    EAGLContext *_context;
    CAEAGLLayer *_eagllayer;
    GLuint _colorRenderBuffer;
    GLuint _frameBuffer;
}

+ (Class)layerClass{
    return [CAEAGLLayer class];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self setupLayer];
    [self setupContext];
    [self destoryRenderAndFrameBuffer];
    [self setupRenderBuffer];
    [self setupFrameBuffer];
    [self render];
}

-(void)setupLayer{
    _eagllayer = (CAEAGLLayer *)self.layer;
    _eagllayer.opaque = YES;
    _eagllayer.drawableProperties = @{
                                      kEAGLDrawablePropertyRetainedBacking : @(NO),
                                      kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8
                                      };
}

-(void)setupContext{
    _context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!_context) return;
    [EAGLContext setCurrentContext:_context];
}

-(void)setupRenderBuffer{
    glGenBuffers(1, &_colorRenderBuffer);
    glBindBuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eagllayer];
}

-(void)setupFrameBuffer{
    glGenBuffers(1, &_frameBuffer);
    glBindBuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
}

-(void)render{
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

-(void)destoryRenderAndFrameBuffer{
    glDeleteBuffers(1, &_frameBuffer);
    _frameBuffer = 0;
    
    glDeleteBuffers(1, &_colorRenderBuffer);
    _colorRenderBuffer = 0;
}

@end
