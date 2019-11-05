//
//  GLESView1.m
//  OpenGL ES Learning
//
//  Created by 李超群 on 2019/1/25.
//  Copyright © 2019 李超群. All rights reserved.
//

#import "GLESView1.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import "GLESUtils.h"

typedef struct {
    GLint position;
    GLint color;
}CustomLint;

typedef struct {
    float position[4];
    float color[4];
}CustomVertex;


@implementation GLESView1{
    CAEAGLLayer *_glLayer;
    EAGLContext *_glContext;
    
    GLuint _colorRenderBuffer;
    GLuint _frameBuffer;
    
    GLint _programHandle;
    
    CustomLint _lint;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setuplayer];
    [self setupContext];
    [self destoryRenderAndFrameBuffer];

    [self setupRenderBuffer];
    [self setupFrameBuffer];
    [self setupProgramHandle];
    
    [self render];
    
}

+(Class)layerClass{
    return [CAEAGLLayer class];
}

- (void)setuplayer{
    _glLayer =  (CAEAGLLayer *)self.layer;
    _glLayer.opaque = YES;
    [_glLayer setDrawableProperties:@{
                                      kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8,
                                      kEAGLDrawablePropertyRetainedBacking : @(NO)
                                      }];
}

-(void)setupContext{
    _glContext = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:_glContext];
}

-(void)setupRenderBuffer{
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_glLayer];
}

-(void)setupFrameBuffer{
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
}

-(void)setupProgramHandle{
    NSString * vertextShaderPath = [[NSBundle mainBundle] pathForResource:@"VertextShader1" ofType:@"glsl"];
    NSString * fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"FragmentShader1" ofType:@"glsl"];
    
    GLuint vertextShader = [GLESUtils loadShader:GL_VERTEX_SHADER withFilepath:vertextShaderPath];
    GLuint framegmentShader = [GLESUtils loadShader:GL_FRAGMENT_SHADER withFilepath:fragmentShaderPath];
    
    _programHandle = glCreateProgram();
    glAttachShader(_programHandle, vertextShader);
    glAttachShader(_programHandle, framegmentShader);
    glLinkProgram(_programHandle);
    glUseProgram(_programHandle);

    _lint.position = glGetAttribLocation(_programHandle, "position");
    _lint.color = glGetAttribLocation(_programHandle, "color");
    
    glEnableVertexAttribArray(_lint.position);
    glEnableVertexAttribArray(_lint.color);
}

-(void)render{
    glClearColor(0, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    CustomVertex lint1 = {.position = {-1.0,  1.0, 0, 1}, .color = {1, 0, 0, 1 }};
    CustomVertex lint2 = {.position = {-1.0,  -1.0, 0, 1}, .color = {0, 1, 0, 1 }};
    CustomVertex lint3 = {.position = {1.0,  -1.0, 0, 1}, .color = {0, 0, 1, 1 }};
    CustomVertex vertices[] ={lint1, lint2, lint3};
    
    // - 创建顶点缓存对象 (参数一: 需要创建的顶点缓存的个数, 参数二: 用于存储创建好的顶点缓存对象的句柄)
    GLuint vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    
    // - 将顶点缓存对象设置为当前数组缓存对象(将GL_ARRAY_BUFFER 绑定为 vertexBuffer)
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    
    // - 把用户定义的数据复制到当前绑定缓冲
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    // - 颜色和位置都是四元向量
    int vectorSize = 4;
    
    // - 链接顶点属性
    glVertexAttribPointer(_lint.position, vectorSize, GL_FLOAT, GL_FALSE,  sizeof(CustomVertex), 0);
    glVertexAttribPointer(_lint.color, vectorSize, GL_FLOAT, GL_FALSE, sizeof(CustomVertex), (GLvoid *)(sizeof(GL_FLOAT) * vectorSize));
    glDrawArrays(GL_TRIANGLES, 0, 3);
    [_glContext presentRenderbuffer:GL_RENDERBUFFER];
}

-(void)destoryRenderAndFrameBuffer{
    glDeleteBuffers(1, &_frameBuffer);
    _frameBuffer = 0;
    
    glDeleteBuffers(1, &_colorRenderBuffer);
    _colorRenderBuffer = 0;
}

@end
