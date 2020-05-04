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
    GLuint _texture, _frameBuffer;
    NSString *_name;
}

-(instancetype)initWithimageName:(NSString *)imageName{
    self = [super init];
    if (self) {
        _name = imageName;
        [self setuptexture];
        [self setupFrameBuffer];
    }
    return self;
}

-(void)setupFrameBuffer{
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
}

-(void)setuptexture{
    if (_name) {
            CGImageRef imgRef = [UIImage imageNamed:_name].CGImage;
        size_t width = CGImageGetWidth(imgRef);
        size_t height = CGImageGetHeight(imgRef);
        GLubyte *imgData = (GLubyte *)calloc(width * height * 4, sizeof(GLbyte));

        CGContextRef contextRef = CGBitmapContextCreate(imgData, width, height, 8, width * 4, CGImageGetColorSpace(imgRef), kCGImageAlphaPremultipliedLast);
        
        // - 翻转纹理坐标
        CGRect rect = CGRectMake(0, 0, width, height);
        CGContextTranslateCTM(contextRef, 0, rect.size.height);
        CGContextScaleCTM(contextRef, 1.0, -1.0);
        
        // - 绘制图片
        CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imgRef);
        CGContextRelease(contextRef);
        
        glGenTextures(1, &_texture);
        glBindTexture(GL_TEXTURE_2D, _texture);
        
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

        // - 生成一个纹理对象
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imgData);
        free(imgData);

    }else{
        glGenTextures(1, &_texture);
        glBindTexture(GL_TEXTURE_2D, _texture);
        
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

        // - 生成一个纹理对象
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)500, (GLsizei)889, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);

    }
}

- (GLuint)texture{
    return _texture;
}

/** 纹理索引 */
-(GLuint)frameBuffer{
    return _frameBuffer;
}

@end
