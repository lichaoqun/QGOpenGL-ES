//
//  QGGrayscaleFilter.m
//  OpenGL ES Learning
//
//  Created by QG on 2020/5/6.
//  Copyright © 2020 李超群. All rights reserved.
//

#import "QGGrayscaleFilter.h"
#import "QGShaderCompiler.h"
#import "QGFrameBufferObject.h"
#import "QGFilterInputProtocol.h"
#import "QGFilterOutputProtocol.h"

@interface QGGrayscaleFilter ()<QGFilterInputProtocol, QGFilterOutputProtocol>

/** 三个通用变量 */
@property(nonatomic, assign) GLuint position, textureCoordinate, colorMap, lastColorMap;

/** 渲染的尺寸 */
@property(nonatomic, assign)CGSize renderSize;

/** 三个通用变量 */
@property(nonatomic, strong) QGShaderCompiler *shaderCompiler;

@property(nonatomic, strong) QGFrameBufferObject *frameBuffer;

@end

@implementation QGGrayscaleFilter

- (instancetype)initWithSize:(CGSize)renderSize
{
    self = [super init];
    if (self) {
        self.renderSize = renderSize;
        [self setupShaderCompiler];
        [self setupFrameBufferObject];
    }
    return self;
}


-(void)setupShaderCompiler{
    QGShaderCompiler *shaderCompiler = [[QGShaderCompiler alloc]initWithvshaderFileName:@"VertextShader2" fshaderFileName:@"FragmentShader2_06"];
    _position = [shaderCompiler addAttribute:@"position"];
    _textureCoordinate = [shaderCompiler addAttribute:@"textCoordinate"];
    _colorMap = [shaderCompiler addUniform:@"colorMap"];
}

-(void)setupFrameBufferObject{
    self.frameBuffer = [[QGFrameBufferObject alloc]initWithSize:self.renderSize];
}

- (void)lastTextureID:(GLuint)textureId{
    self.lastColorMap = textureId;
}

-(void)render{
    [self.shaderCompiler glUseProgram];
    [self.frameBuffer activityFrameBuffer];
    glClearColor(1, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, self.renderSize.width, self.renderSize.height);

    /* 为了统一代码, 修改了代码, 原来的实现在注释中
     已知源纹理的输出纹理单元为 GL_TEXTURE0;
     下边的 glUniform1i(_uni1, 0) 是将 GL_TEXTURE0 作为 self.shaderCompiler1 的输入纹理,
     QGFrameBuffer 中的 glActiveTexture(GL_TEXTURE1); 是将 GL_TEXTURE1, 作为帧缓冲纹理输出单元;
     
     之前的代码的实现:
     glUniform1i(_uni1, 0);
     */
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, self.lastColorMap);
    glUniform1i(_colorMap, 2);

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

@end
