//
//  QGGLESView.m
//  OpenGL ES Learning
//
//  Created by QG on 2020/5/4.
//  Copyright © 2020 李超群. All rights reserved.
//

#import "QGGLESView.h"
#import "QGEAGLContext.h"
#import "QGShaderCompiler.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

@interface QGGLESView ()

/** 三个通用变量 */
@property(nonatomic, assign) GLuint position, textureCoordinate, colorMap;

/** 三个通用变量 */
@property(nonatomic, strong) QGShaderCompiler *shaderCompiler;

@end

@implementation QGGLESView{
    GLuint _frameBuffer;
    CAEAGLLayer *_glLayer;
    GLuint _textureId;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setuplayer];
        [self setupShaderCompiler];
        [self setupRenderBuffer];
    }
    return self;
}

+(Class)layerClass{
    return [CAEAGLLayer class];
}

/** 设置 layer 的一些属性 */
- (void)setuplayer{
    _glLayer =  (CAEAGLLayer *)self.layer;
    _glLayer.opaque = YES;
    [_glLayer setDrawableProperties:@{
                                      kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8,
                                      kEAGLDrawablePropertyRetainedBacking : @(NO)
                                      }];
}

-(void)setupShaderCompiler{
    self.shaderCompiler = [[QGShaderCompiler alloc]initWithvshaderFileName:@"VertextShader2" fshaderFileName:@"FragmentShader2_00"];
    _position = [self.shaderCompiler addAttribute:@"position"];
    _textureCoordinate = [self.shaderCompiler addAttribute:@"textCoordinate"];
    _colorMap = [self.shaderCompiler addUniform:@"colorMap"];
}
/** 设置缓冲数据 */
-(void)setupRenderBuffer{
    EAGLContext *context = [QGEAGLContext sharedInstance].glContext;
    
    // - 生成renderbuffer ( renderbuffer = 用于展示的窗口 )
    GLuint renderBuffer;
    glGenRenderbuffers(1, &renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, renderBuffer);
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_glLayer];
    
    glGenFramebuffers(1, &_frameBuffer);
    // 绑定 fraembuffer
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    // framebuffer 不对绘制的内容做存储, 所以这一步是将 framebuffer 绑定到 renderbuffer ( 绘制的结果就存在 renderbuffer )
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                              GL_RENDERBUFFER, renderBuffer);
}

/** 激活帧缓冲 */
-(void)activityFrameBuffer{
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
}
-(void)render{
    [self.shaderCompiler glUseProgram];
    [self activityFrameBuffer];
    glClearColor(1, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    /*
     前边已知self.frameBuffer2的输出纹理单元为 GL_TEXTURE1;
     glActiveTexture(GL_TEXTURE2); 和 glBindTexture(GL_TEXTURE_2D, [self.frameBuffer1 textureID]); 是将 self.frameBuffer2的输出纹理单元从 GL_TEXTURE1 改为 GL_TEXTURE2;
     glUniform1i(_uni2, 2) 是将 GL_TEXTURE2 作为 self.shaderCompiler3 的输入纹理;
     帧缓冲纹理输出单元渲染到屏幕上;
     */
    glActiveTexture(GL_TEXTURE3);
    glBindTexture(GL_TEXTURE_2D, _textureId);
    glUniform1i(_colorMap, 3);


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

    [[QGEAGLContext sharedInstance] presentRenderbuffer];

}

- (void)setLastTextureID:(GLuint)lastTextureID{
    _textureId = lastTextureID;
}
@end
