//
//  QGFrameBuffer.m
//  OpenGL ES Learning
//
//  Created by QG on 2020/5/4.
//  Copyright © 2020 李超群. All rights reserved.
//

#import "QGFrameBuffer.h"
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

@implementation QGFrameBuffer{
    GLuint _textureID, _frameBufferID;
}

-(instancetype)initWithSize:(CGSize)size{
    self = [super init];
    if (self) {
        [self setuptextureSize:size];
    }
    return self;
}
-(void)setuptextureSize:(CGSize)size{
    glGenFramebuffers(1, &_frameBufferID);
    glActiveTexture(GL_TEXTURE0);
    glGenTextures(1, &_textureID);
    glBindTexture(GL_TEXTURE_2D, _textureID);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, size.width, size.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBufferID);
    
    // - 生成一个纹理对象
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,GL_TEXTURE_2D, _textureID, 0);
}

- (GLuint)textureID{
    return _textureID;
}

- (GLuint)framebufferID{
    return _frameBufferID;
}

/** 激活帧缓冲 */
-(void)activityFrameBuffer{
    glActiveTexture(GL_TEXTURE0);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBufferID);
}


@end
