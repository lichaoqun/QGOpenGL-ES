//
//  QGShaderCompiler.h
//  OpenGL ES Learning
//
//  Created by QG on 2020/5/4.
//  Copyright © 2020 李超群. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils/GLESUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface QGShaderCompiler : NSObject

-(void)glUseProgram:(GLuint)program;

@end

NS_ASSUME_NONNULL_END
