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
#import "QGEAGLContext.h"

@implementation QGInputImage

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
    
    // - 激活OpenGLES 上下文
    [QGEAGLContext sharedInstance];
    
    
    GLuint textureID;
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
    glGenTextures(1, &textureID);
    glBindTexture(GL_TEXTURE_2D, textureID);
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
    _lastTextureID = textureID;
}


-(void)setFilters:(NSArray<QGOutputBase<QGFilterInputProtocol> *> *)filters{
    _filters = filters;
    for (QGOutputBase <QGFilterInputProtocol> * filter in filters) {
        [filter setLastTextureID:_lastTextureID];
        _lastTextureID = [filter getCurrentTextureId];
    }
}

-(void)startRenderInView:(UIView<QGFilterInputProtocol> *)renderView{
    for (QGOutputBase <QGFilterInputProtocol> * filter in self.filters) {
        [filter render];
    }
    [renderView setLastTextureID:_lastTextureID];
    [renderView render];
}
@end
