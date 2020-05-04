//
//  QGGLESView.m
//  OpenGL ES Learning
//
//  Created by QG on 2020/5/4.
//  Copyright © 2020 李超群. All rights reserved.
//

#import "QGGLESView.h"

@implementation QGGLESView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setuplayer];
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

@end
