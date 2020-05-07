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
#import "QGFrameBufferObject.h"

@interface QGDemo01()

@property(nonatomic, strong)QGShaderCompiler *shaderCompiler1;
@property(nonatomic, strong)QGShaderCompiler *shaderCompiler2;
@property(nonatomic, strong)QGShaderCompiler *shaderCompiler3;

@property(nonatomic, strong)QGFrameBufferObject *frameBuffer1;
@property(nonatomic, strong)QGFrameBufferObject *frameBuffer2;

@end

@implementation QGDemo01{
    GLuint _position1, _texture1;
    GLuint _position2, _texture2;
    GLuint _position3, _texture3;
    GLuint _uni1, _uni2, _uni3;
    GLuint _srcTextureID;
    CGSize _bufferSize;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInputTexture];
        [self setupFrameBufferObj];
        [self setupShader];
        [self render1];
        [self render2];
        [self render3];

    }
    return self;
}

-(void)setupInputTexture{
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
    glGenTextures(1, &_srcTextureID);
    glBindTexture(GL_TEXTURE_2D, _srcTextureID);
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
    // - 解绑
    glBindTexture(GL_TEXTURE_2D, 0);
    free(imageData);
}


-(void)setupShader{
    self.shaderCompiler1 = [[QGShaderCompiler alloc]initWithvshaderFileName:@"VertextShader2" fshaderFileName:@"FragmentShader2_06"];
    _position1 = [self.shaderCompiler1 addAttribute:@"position"];
    _texture1 = [self.shaderCompiler1 addAttribute:@"textCoordinate"];
    _uni1 = [self.shaderCompiler1 addUniform:@"colorMap"];

    
    self.shaderCompiler2 = [[QGShaderCompiler alloc]initWithvshaderFileName:@"VertextShader2" fshaderFileName:@"FragmentShader2_04"];
    _position2 = [self.shaderCompiler2 addAttribute:@"position"];
    _texture2 = [self.shaderCompiler2 addAttribute:@"textCoordinate"];
    _uni2 = [self.shaderCompiler2 addUniform:@"colorMap"];


    self.shaderCompiler3 = [[QGShaderCompiler alloc]initWithvshaderFileName:@"VertextShader2" fshaderFileName:@"FragmentShader2_14"];
    _position3 = [self.shaderCompiler3 addAttribute:@"position"];
    _texture3 = [self.shaderCompiler3 addAttribute:@"textCoordinate"];
    _uni3 = [self.shaderCompiler3 addUniform:@"colorMap"];
}


-(void)setupFrameBufferObj{
    self.frameBuffer1 = [[QGFrameBufferObject alloc]initWithSize:self.frame.size];
    self.frameBuffer2 = [[QGFrameBufferObject alloc]initWithSize:self.frame.size];
}

-(void)render1{
    [self.shaderCompiler1 glUseProgram];
    [self.frameBuffer1 activityFrameBuffer];
    glClearColor(1, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);

    /* 为了统一代码, 修改了代码, 原来的实现在注释中
     已知源纹理的输出纹理单元为 GL_TEXTURE0;
     下边的 glUniform1i(_uni1, 0) 是将 GL_TEXTURE0 作为 self.shaderCompiler1 的输入纹理,
     QGFrameBuffer 中的 glActiveTexture(GL_TEXTURE1); 是将 GL_TEXTURE1, 作为帧缓冲纹理输出单元;
     
     之前的代码的实现:
     glUniform1i(_uni1, 0);
     */
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, _srcTextureID);
    glUniform1i(_uni1, 2);

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
    
    /*
     前边已知self.frameBuffer1的输出纹理单元为 GL_TEXTURE1;
     glActiveTexture(GL_TEXTURE2); 和 glBindTexture(GL_TEXTURE_2D, [self.frameBuffer1 textureID]); 是将 self.frameBuffer1的输出纹理单元从 GL_TEXTURE1 改为 GL_TEXTURE2;
     glUniform1i(_uni2, 2) 是将 GL_TEXTURE2 作为 self.shaderCompiler2 的输入纹理;
     QGFrameBuffer 中的 glActiveTexture(GL_TEXTURE1); 是将 GL_TEXTURE1, 作为帧缓冲纹理输出单元;
     */
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, [self.frameBuffer1 textureID]);
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
    [self activityFrameBuffer];
    glClearColor(0, 0, 1, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    /*
     前边已知self.frameBuffer2的输出纹理单元为 GL_TEXTURE1;
     glActiveTexture(GL_TEXTURE2); 和 glBindTexture(GL_TEXTURE_2D, [self.frameBuffer1 textureID]); 是将 self.frameBuffer2的输出纹理单元从 GL_TEXTURE1 改为 GL_TEXTURE2;
     glUniform1i(_uni2, 2) 是将 GL_TEXTURE2 作为 self.shaderCompiler3 的输入纹理;
     帧缓冲纹理输出单元渲染到屏幕上;
     */
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, [self.frameBuffer2 textureID]);
    glUniform1i(_uni3, 2);


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

    [[QGEAGLContext sharedInstance] presentRenderbuffer];

}
@end
