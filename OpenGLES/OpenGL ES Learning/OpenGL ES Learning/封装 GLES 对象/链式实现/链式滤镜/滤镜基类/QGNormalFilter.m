//
//  QGGrayscaleFilter.m
//  OpenGL ES Learning
//
//  Created by QG on 2020/5/6.
//  Copyright © 2020 李超群. All rights reserved.
//

#import "QGNormalFilter.h"
#import "QGShaderCompiler.h"
#import "QGFrameBufferObject.h"
#import "QGFilterInputProtocol.h"

@interface QGNormalFilter ()

/** 三个通用变量 */
@property(nonatomic, assign) GLuint position, textureCoordinate, colorMap, lastColorMap;

/** 渲染的尺寸 */
@property(nonatomic, assign)CGSize renderSize;

/** 三个通用变量 */
@property(nonatomic, strong) QGShaderCompiler *shaderCompiler;

@property(nonatomic, strong) QGFrameBufferObject *frameBuffer;

@end

@implementation QGNormalFilter

- (instancetype)initWithSize:(CGSize)renderSize{
    return [self initWithSize:renderSize filterName:@"FragmentShader2_06"];
}

- (instancetype)initWithSize:(CGSize)renderSize filterName:(NSString *)filterName{
    self = [super init];
    if (self) {
        self.renderSize = renderSize;
        [self setupShaderCompilerWitName:filterName];
        [self setupFrameBufferObject];
    }
    return self;
}

-(void)setupShaderCompilerWitName:(NSString *)fileName{
    self.shaderCompiler = [[QGShaderCompiler alloc]initWithvshaderFileName:@"VertextShader2" fshaderFileName:fileName];
    _position = [self.shaderCompiler addAttribute:@"position"];
    _textureCoordinate = [self.shaderCompiler addAttribute:@"textCoordinate"];
    _colorMap = [self.shaderCompiler addUniform:@"colorMap"];
}

-(void)setupFrameBufferObject{
    self.frameBuffer = [[QGFrameBufferObject alloc]initWithSize:self.renderSize];
}

-(void)render{
    /* 为了统一代码, 修改了代码, 原来的实现在注释中
     已知源纹理的输出纹理单元为 GL_TEXTURE0;
     下边的 glUniform1i(_uni1, 0) 是将 GL_TEXTURE0 作为 self.shaderCompiler1 的输入纹理,
     QGFrameBuffer 中的 glActiveTexture(GL_TEXTURE1); 是将 GL_TEXTURE1, 作为帧缓冲纹理输出单元;
     
     之前的代码的实现:
     glUniform1i(_uni1, 0);
     */
    [self.frameBuffer activityFrameBuffer];
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, _lastTextureID);
    
    [self.shaderCompiler glUseProgram];
    glUniform1i(_colorMap, 2);

    glClearColor(1, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, self.renderSize.width, self.renderSize.height);

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
    
    glVertexAttribPointer(_position, 3, GL_FLOAT, GL_FALSE,  sizeof(GLfloat) * 3, vertices);
    glVertexAttribPointer(_textureCoordinate, 2, GL_FLOAT, GL_FALSE,  sizeof(GLfloat) * 2, texturecoords);
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

-(GLuint)getCurrentTextureId{
    return self.frameBuffer.textureID;
}

-(void)setLastTextureID:(GLuint)lastTextureID{
    _lastTextureID = lastTextureID;
}

@end
