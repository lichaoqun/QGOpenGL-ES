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
#import "QGFrameBuffer.h"

@interface QGDemo01()
@property(nonatomic, strong)QGEAGLContext *context;
@property(nonatomic, strong)QGShaderCompiler *shaderCompiler1;
@property(nonatomic, strong)QGShaderCompiler *shaderCompiler2;
@property(nonatomic, strong)QGFrameBuffer *frameBuffer1;
@property(nonatomic, strong)QGFrameBuffer *frameBuffer2;


@end

@implementation QGDemo01{
    GLuint _position1, _texture1;
    GLuint _position2, _texture2;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupGLESContext];
        [self setupShader];
        [self setupTexture];
        [self render];
    }
    return self;
}

/** 设置 GLES上下文 */
-(void)setupGLESContext{
    self.context = [[QGEAGLContext alloc]init];
}

// - 00 01 06
-(void)setupShader{
    self.shaderCompiler1 = [[QGShaderCompiler alloc]initWithvshaderFileName:@"VertextShader2" fshaderFileName:@"FragmentShader2_01"];
    _position1 = [self.shaderCompiler1 addAttribute:@"position"];
    _texture1 = [self.shaderCompiler1 addAttribute:@"textCoordinate"];
    
//    self.shaderCompiler2 = [[QGShaderCompiler alloc]initWithvshaderFileName:@"VertextShader2" fshaderFileName:@"FragmentShader2_01"];
//    _position2 = [self.shaderCompiler2 addAttribute:@"position"];
//    _texture2 = [self.shaderCompiler2 addAttribute:@"textCoordinate"];
}


-(void)setupTexture{
    self.frameBuffer2 = [[QGFrameBuffer alloc]initWithimageName:@"gyy.jpg"];
//    self.frameBuffer2 = [[QGFrameBuffer alloc]initWithimageName:nil];

}

-(void)render{
    GLuint colorRenderBuffer;
    glGenRenderbuffers(1, &colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
    [self.context.glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.glLayer];
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderBuffer);

    [self.shaderCompiler1 glUseProgram];
    glClearColor(0, 1, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);

    GLfloat vertices[] = {
        1.0, 1.0, 0.0,
        1.0, -1.0, 0.0,
        -1.0, 1.0, 0.0,
        
        1.0, -1.0, 0.0,
        -1.0, -1.0, 0.0,
        -1.0, 1.0, 0.0};
    
    GLfloat texturecoords[] ={
        1.0, 1.0,
        1.0, 0.0,
        0.0, 1.0,
        1.0, 0.0,
        0.0, 0.0,
        0.0, 1.0};
    
    
    
    
//    glBindBuffer(GL_FRAMEBUFFER, [self.frameBuffer2 texture]);
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);

    
//    glBindBuffer(GL_TEXTURE_2D, [self.frameBuffer1 texture]);
    glVertexAttribPointer(_position1, 3, GL_FLOAT, GL_FALSE,  sizeof(GLfloat) * 3, vertices);
    glVertexAttribPointer(_texture1, 2, GL_FLOAT, GL_FALSE,  sizeof(GLfloat) * 2, texturecoords);
    glDrawArrays(GL_TRIANGLES, 0, 6);







    [self.context present];
}

@end
