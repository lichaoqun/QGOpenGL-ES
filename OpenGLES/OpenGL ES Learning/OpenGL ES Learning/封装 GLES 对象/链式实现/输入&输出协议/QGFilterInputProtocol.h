//
//  QGFilterInputProtoco.h
//  OpenGL ES Learning
//
//  Created by QG on 2020/5/6.
//  Copyright © 2020 李超群. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QGFilterInputProtocol <NSObject>

-(void)setLastTextureID:(GLuint)lastTextureID;

-(GLuint)getCurrentTextureId;

-(void)render;

@end

NS_ASSUME_NONNULL_END
