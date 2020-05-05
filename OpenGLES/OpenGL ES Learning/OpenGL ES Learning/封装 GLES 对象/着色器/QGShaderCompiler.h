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
/** 直接使用字符串 */
- (instancetype)initWithvshader:(NSString *)vshader fshader:(NSString *)fshader;

/** 使用文件 */
- (instancetype)initWithvshaderPath:(NSString *)vshaderPath fshaderPath:(NSString *)fshaderPath;

/** 使用文件(后缀需要是.glsl) */
- (instancetype)initWithvshaderFileName:(NSString *)vshaderName fshaderFileName:(NSString *)fshaderName;

/** 添加属性 */
- (GLuint)addAttribute:(NSString *)attributeName;

/** 添加属性 */
- (GLuint)addUniform:(NSString *)attributeName;

/** 使用某个着色器程序 */
-(void)glUseProgram;

@end

NS_ASSUME_NONNULL_END
