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
@property(nonatomic, strong)QGShaderCompiler *shaderCompiler3;

@property(nonatomic, strong)QGFrameBuffer *frameBuffer1;
@property(nonatomic, strong)QGFrameBuffer *frameBuffer2;

@end

@implementation QGDemo01{
    GLuint _position1, _texture1;
    GLuint _position2, _texture2;
    GLuint _position3, _texture3;
    GLuint _frameBuffer, _renderBuffer;
    GLuint _uni1, _uni2, _uni3;
    CGSize _bufferSize;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupGLESContext];
        [self setupBuffer];
        [self setupTexture];
        [self setupShader];
        [self render1];
        [self render2];
        [self render3];

    }
    return self;
}

/** 设置 GLES上下文 */
-(void)setupGLESContext{
    self.context = [[QGEAGLContext alloc]init];
}

-(void)setupBuffer{
    // 生成renderbuffer ( renderbuffer = 用于展示的窗口 )
    glGenRenderbuffers(1, &_renderBuffer);
    // 绑定renderbuffer
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    // GL_RENDERBUFFER 的内容存储到实现 EAGLDrawable 协议的 CAEAGLLayer
    [self.context.glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.glLayer];
    
    glGenFramebuffers(1, &_frameBuffer);
    // 绑定 fraembuffer
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    // framebuffer 不对绘制的内容做存储, 所以这一步是将 framebuffer 绑定到 renderbuffer ( 绘制的结果就存在 renderbuffer )
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                              GL_RENDERBUFFER, _renderBuffer);
    
    GLuint texture;
    UIImage *image = [UIImage imageNamed:@"gyy.jpg"];
    size_t width = CGImageGetWidth(image.CGImage);
    size_t height = CGImageGetHeight(image.CGImage);
    _bufferSize = CGSizeMake(width, height);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *imageData = malloc( height * width * 4 );
    
    CGContextRef context = CGBitmapContextCreate(imageData,
                                                 width,
                                                 height,
                                                 8,
                                                 4 * width,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGColorSpaceRelease( colorSpace );
    CGContextClearRect( context, CGRectMake( 0, 0, width, height ) );
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM (context, 1.0,-1.0);
    CGContextDrawImage( context, CGRectMake( 0, 0, width, height ), image.CGImage );
    CGContextRelease(context);
    glActiveTexture(GL_TEXTURE0 + 2);
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D,
                 0,
                 GL_RGBA,
                 (GLint)width,
                 (GLint)height,
                 0,
                 GL_RGBA,
                 GL_UNSIGNED_BYTE,
                 imageData);
    free(imageData);
}


-(void)setupShader{
    self.shaderCompiler1 = [[QGShaderCompiler alloc]initWithvshaderFileName:@"VertextShader2" fshaderFileName:@"FragmentShader2_00"];
    _position1 = [self.shaderCompiler1 addAttribute:@"position"];
    _texture1 = [self.shaderCompiler1 addAttribute:@"textCoordinate"];
    _uni1 = [self.shaderCompiler1 addUniform:@"colorMap"];

    
    self.shaderCompiler2 = [[QGShaderCompiler alloc]initWithvshaderFileName:@"VertextShader2" fshaderFileName:@"FragmentShader2_01"];
    _position2 = [self.shaderCompiler2 addAttribute:@"position"];
    _texture2 = [self.shaderCompiler2 addAttribute:@"textCoordinate"];
    _uni2 = [self.shaderCompiler2 addUniform:@"colorMap"];


    self.shaderCompiler3 = [[QGShaderCompiler alloc]initWithvshaderFileName:@"VertextShader2" fshaderFileName:@"FragmentShader2_06"];
    _position3 = [self.shaderCompiler3 addAttribute:@"position"];
    _texture3 = [self.shaderCompiler3 addAttribute:@"textCoordinate"];
    _uni3 = [self.shaderCompiler3 addUniform:@"colorMap"];

}


-(void)setupTexture{
    self.frameBuffer1 = [[QGFrameBuffer alloc]initWithSize:_bufferSize];
    self.frameBuffer2 = [[QGFrameBuffer alloc]initWithSize:_bufferSize];
}

-(void)render1{
    [self.shaderCompiler1 glUseProgram];
    [self.frameBuffer1 activityFrameBuffer];

    glClearColor(1, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    glUniform1i(_uni1, 0);

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
    
    glVertexAttribPointer(_position1, 3, GL_FLOAT, GL_FALSE,  sizeof(GLfloat) * 3, vertices);
    glVertexAttribPointer(_texture1, 2, GL_FLOAT, GL_FALSE,  sizeof(GLfloat) * 2, texturecoords);
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

-(void)render2{
    [self.shaderCompiler2 glUseProgram];
    [self.frameBuffer2 activityFrameBuffer];

    glClearColor(0, 1, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    glUniform1i(_uni2, 2);
    
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
    
    glVertexAttribPointer(_position2, 3, GL_FLOAT, GL_FALSE,  sizeof(GLfloat) * 3, vertices);
    glVertexAttribPointer(_texture2, 2, GL_FLOAT, GL_FALSE,  sizeof(GLfloat) * 2, texturecoords);
    glDrawArrays(GL_TRIANGLES, 0, 6);

}

-(void)render3{
    [self.shaderCompiler3 glUseProgram];
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glBindRenderbuffer(GL_FRAMEBUFFER, _renderBuffer);
    glClearColor(0, 0, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    glUniform1i(_uni3, 0);

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
    

    glVertexAttribPointer(_position3, 3, GL_FLOAT, GL_FALSE,  sizeof(GLfloat) * 3, vertices);
    glVertexAttribPointer(_texture3, 2, GL_FLOAT, GL_FALSE,  sizeof(GLfloat) * 2, texturecoords);
    glDrawArrays(GL_TRIANGLES, 0, 6);

    [self.context present];

}
@end
