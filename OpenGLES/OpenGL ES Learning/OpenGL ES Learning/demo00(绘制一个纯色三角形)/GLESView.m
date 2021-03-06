//
//  GLESView.m
//  OpenGL ES Learning
//
//  Created by 李超群 on 2019/1/24.
//  Copyright © 2019 李超群. All rights reserved.
//

#import "GLESView.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import "GLESUtils.h"

@implementation GLESView{
    CAEAGLLayer *_gllayer;
    EAGLContext *_glcontext;
    
    GLuint _renderBuffer;
    GLuint _frameBuffer;
    
    GLuint _programHandle;
    GLuint _positionSlot;
}

+(Class)layerClass{
    return [CAEAGLLayer class];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self setupLayer];
    [self setupContext];
    
    [self destoryRenderAndFrameBuffer];
    
    [self setupRenderBuffer];
    [self setupFrameBuffer];
    [self setupProgram];
    
    [self render];
}

- (void)setupLayer{
    _gllayer = (CAEAGLLayer *)self.layer;
    _gllayer.opaque = YES;
    _gllayer.drawableProperties = @{
                                  kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8,
                                  kEAGLDrawablePropertyRetainedBacking : @(NO)
                                  };
}

-(void)setupContext{
    
    // - iOS应用程序中的每个线程都有一个当前上下文 要设置线程的当前上下文，请在该线程上执行时调用EAGLContext类方法setCurrentContext：
    _glcontext = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:_glcontext];
}

-(void)setupRenderBuffer{
    // - 帧缓冲区和渲染缓冲区 https://blog.csdn.net/majiakun1/article/details/80416961
    glGenRenderbuffers(1, &_renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    [_glcontext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_gllayer];
}

-(void)setupFrameBuffer{
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
}

-(void)setupProgram{
    NSString * vertextShaderPath = [[NSBundle mainBundle] pathForResource:@"VertexShader" ofType:@"glsl"];
    NSString * fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"FragmentShader" ofType:@"glsl"];
    GLuint vertextShader = [GLESUtils loadShader:GL_VERTEX_SHADER withFilepath:vertextShaderPath];
    GLuint fragmentShader = [GLESUtils loadShader:GL_FRAGMENT_SHADER withFilepath:fragmentShaderPath];
    
    _programHandle = glCreateProgram();
    glAttachShader(_programHandle, vertextShader);
    glAttachShader(_programHandle, fragmentShader);
    
    glLinkProgram(_programHandle);
    glUseProgram(_programHandle);
    _positionSlot = glGetAttribLocation(_programHandle, "vPosition");
}

// - 绘制三角形
-(void)render{
    glClearColor(0, 1.0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    GLfloat vertices[] = {
        -1.0,  1.0, 0, // - 屏幕左上
        -1.0,  -1.0, 0, // - 屏幕左下
        1.0,  -1.0, 0, // - 屏幕右下
    };
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    // - 链接顶点属性
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(GL_FLOAT) * 3, vertices);
    glEnableVertexAttribArray(_positionSlot);

    // - 绘制图形 (3 表示有三个顶点)
    glDrawArrays(GL_TRIANGLES, 0, 3);
    [_glcontext presentRenderbuffer:GL_RENDERBUFFER];
}

// - 绘制四边形
- (void)render1{
    glClearColor(0, 1.0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // - 注意 要想绘制成四边形, 那么两个三角形重合的两个点必须是对角的两个点, 不能是相邻的两个点, 可以试试画图,就很明白了
    GLfloat vertices[] = {
        -1.0,  1.0, 0,// - 屏幕左上
        -1.0,  -1.0, 0, // - 屏幕左下,
        1.0,  -1.0, 0,// - 屏幕右下
        
        -1.0,  1.0, 0,// - 屏幕左上
        1.0,  -1.0, 0, // - 屏幕右下
        1.0,  1.0, 0,// - 屏幕右说
    };
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    // - 链接顶点属性
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(GL_FLOAT) * 3, vertices);
    glEnableVertexAttribArray(_positionSlot);

    // - 绘制图形
    glDrawArrays(GL_TRIANGLES, 0, 6);
    [_glcontext presentRenderbuffer:GL_RENDERBUFFER];
}

-(void)destoryRenderAndFrameBuffer{
    glDeleteBuffers(1, &_frameBuffer);
    _frameBuffer = 0;
    
    glDeleteBuffers(1, &_renderBuffer);
    _renderBuffer = 0;
}
@end
