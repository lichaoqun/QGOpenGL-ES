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


NS_ASSUME_NONNULL_BEGIN

@interface QGFrameBuffer : NSObject

-(instancetype)initWithimageName:(NSString *)imageName;

/** 纹理索引 */
-(GLuint)texture;

/** 纹理索引 */
-(GLuint)frameBuffer;
@end

NS_ASSUME_NONNULL_END
