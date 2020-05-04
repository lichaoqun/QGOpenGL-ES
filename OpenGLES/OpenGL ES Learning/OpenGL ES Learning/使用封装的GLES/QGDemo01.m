//
//  QGDmo01.m
//  OpenGL ES Learning
//
//  Created by QG on 2020/5/4.
//  Copyright © 2020 李超群. All rights reserved.
//

#import "QGDemo01.h"
#import "QGShaderCompiler.h"
#import "QGEAGLContext.h"

@interface QGDemo01()
@property(nonatomic, strong)QGEAGLContext *context;
@property(nonatomic, strong)QGShaderCompiler *shaderCompiler;


@end

@implementation QGDemo01{
    GLuint _position, _color;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupGLESContext];
        [self setupShader];
        [self setupBuffer];
        [self render];
    }
    return self;
}

/** 设置 GLES上下文 */
-(void)setupGLESContext{
    self.context = [[QGEAGLContext alloc]init];
}

-(void)setupShader{
    self.shaderCompiler = [[QGShaderCompiler alloc]initWithvshaderFileName:@"VertextShader1" fshaderFileName:@"FragmentShader1"];
    _position = [self.shaderCompiler addAttribute:@"position"];
    _color = [self.shaderCompiler addAttribute:@"color"];
    [self.shaderCompiler glUseProgram];
}

-(void)setupBuffer{
    GLuint colorRenderBuffer, frameBuffer;
    glGenRenderbuffers(1, &colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
    [self.context.glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.glLayer];
    
    glGenFramebuffers(1, &frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderBuffer);
}

-(void)render{

    glClearColor(1, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);

    GLfloat vertices[] = {
        -1.0,  1.0, 0, 1,// - 屏幕左上
        -1.0,  -1.0, 0, 1, // - 屏幕左下,
        1.0,  -1.0, 0, 1,// - 屏幕右下
        
        -1.0,  1.0, 0, 1,// - 屏幕左上
        1.0,  -1.0, 0, 1, // - 屏幕右下
        1.0,  1.0, 0, 1,// - 屏幕右上
    };
    
    GLfloat colors[] = {
        1, 0, 0, 1,
        0, 1, 0, 1,
        0, 0, 1, 1,
        1, 0, 0, 1,
        0, 0, 1, 1,
        1, 1, 0, 1,
    };

    
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    // - 颜色和位置都是四元向量
    int vectorSize = 4;
    
    // - 链接顶点属性(不使用顶点缓冲对象,  每次链接顶点属性时候, 会将 cpu 的数据 拷贝到 GPU 中)
    glVertexAttribPointer(_position, vectorSize, GL_FLOAT, GL_FALSE,  sizeof(GLfloat) * vectorSize , vertices);
    glVertexAttribPointer(_color, vectorSize, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * vectorSize, colors);
    
    // - 绘制图形 四边形 6 个顶点
    glDrawArrays(GL_TRIANGLES, 0, 6);
    [self.context present];
}

@end
