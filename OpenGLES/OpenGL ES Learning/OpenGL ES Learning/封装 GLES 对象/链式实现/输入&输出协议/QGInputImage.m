//
//  QGInputImage.m
//  OpenGL ES Learning
//
//  Created by 李超群 on 2020/5/7.
//  Copyright © 2020 李超群. All rights reserved.
//

#import "QGInputImage.h"
#import <UIKit/UIKit.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

#import "QGGrayscaleFilter.h"


@implementation QGInputImage{
    GLuint _textureID;
    
}

- (instancetype)initWithImageName:(NSString *)imageName;
{
    self = [super init];
    if (self) {
        [self setupInputTextureWithImageName:imageName];
    }
    return self;
}

/** 创建输入纹理 */
-(void)setupInputTextureWithImageName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    size_t width = CGImageGetWidth(image.CGImage);
    size_t height = CGImageGetHeight(image.CGImage);
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
    glGenTextures(1, &_textureID);
    glBindTexture(GL_TEXTURE_2D, _textureID);
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

-(void)addTarget:(id<QGFilterInputProtocol>)target{
    self.target = target;
    [target setInputTextureID:_textureID];
}

-(void)render{
    [self.target render];
}
@end
