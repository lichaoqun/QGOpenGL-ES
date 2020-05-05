//
//  QGGLESView.m
//  OpenGL ES Learning
//
//  Created by QG on 2020/5/4.
//  Copyright © 2020 李超群. All rights reserved.
//

#import "QGGLESView.h"
#import "QGEAGLContext.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

@implementation QGGLESView{
    GLuint _frameBuffer;
    CAEAGLLayer *_glLayer;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setuplayer];
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

@end
