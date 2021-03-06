//
//  QGFrameBuffer.h
//  OpenGL ES Learning
//
//  Created by QG on 2020/5/4.
//  Copyright © 2020 李超群. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface QGFrameBufferObject : NSObject

-(instancetype)initWithSize:(CGSize)size;

/** 纹理索引id */
-(GLuint)textureID;

/** 帧缓冲 id */
- (GLuint)framebufferID;

/** 激活帧缓冲 */
-(void)activityFrameBuffer;

@end

NS_ASSUME_NONNULL_END
