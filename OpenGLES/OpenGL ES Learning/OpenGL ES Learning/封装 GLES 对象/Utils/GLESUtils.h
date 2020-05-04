//
//  GLESUtils.h
//  OpenGL ES Learning
//
//  Created by 李超群 on 2019/1/24.
//  Copyright © 2019 李超群. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface GLESUtils : NSObject

+(GLuint)loadShader:(GLenum)type withFilepath:(NSString *)shaderFilepath;

+(GLuint)loadShader:(GLenum)type withString:(NSString *)shaderString;
@end
