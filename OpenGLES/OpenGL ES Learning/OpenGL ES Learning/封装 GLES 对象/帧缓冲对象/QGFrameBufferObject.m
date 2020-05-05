//
//  QGFrameBuffer.m
//  OpenGL ES Learning
//
//  Created by QG on 2020/5/4.
//  Copyright © 2020 李超群. All rights reserved.
//

#import "QGFrameBufferObject.h"
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

@implementation QGFrameBufferObject{
    GLuint _textureID, _frameBufferID;
}

-(instancetype)initWithSize:(CGSize)size{
    self = [super init];
    if (self) {
        [self setuptextureSize:size];
    }
    return self;
}

/** 设置帧缓冲对象 */
-(void)setuptextureSize:(CGSize)size{
    glGenFramebuffers(1, &_frameBufferID);
    glActiveTexture(GL_TEXTURE1);
    glGenTextures(1, &_textureID);
    glBindTexture(GL_TEXTURE_2D, _textureID);
    
    // - 这里的 size 是需要渲染的填充的view 的size,而不是图片的 size
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, size.width, size.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBufferID);
    
    // - 帧缓冲对象
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,GL_TEXTURE_2D, _textureID, 0);
    
    /*
     解绑纹理, 这句很重要(解绑才能重新绑定新的纹理单元);
     如果要实现链式纹理, 就需要将帧缓冲对象生成的纹理单元最为下一个 shader 纹理的输入;
     glActiveTexture() : 设置帧缓冲的输出纹理单元;
     glUniform1i() : 设置 shader 的纹理的输入; 输入和输出不能是同一个纹理单元;
     */
    glBindTexture(GL_TEXTURE_2D, 0);
}

- (GLuint)textureID{
    return _textureID;
}

- (GLuint)framebufferID{
    return _frameBufferID;
}

/** 激活帧缓冲 */
-(void)activityFrameBuffer{
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBufferID);
}


@end
