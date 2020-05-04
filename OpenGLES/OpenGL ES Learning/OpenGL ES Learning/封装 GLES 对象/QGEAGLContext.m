//
//  QGEAGLContext.m
//  OpenGL ES Learning
//
//  Created by QG on 2020/5/4.
//  Copyright © 2020 李超群. All rights reserved.
//

#import "QGEAGLContext.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import <OpenGLES/EAGLDrawable.h>

@implementation QGEAGLContext

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupContext];
    }
    return self;
}

/** 初始化上下文 */
-(void)setupContext{
    _glContext = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:_glContext];
}

/** 发送到渲染缓冲区, 开始渲染 */
-(void)present{
    [self.glContext presentRenderbuffer:GL_RENDERBUFFER];
}

@end
