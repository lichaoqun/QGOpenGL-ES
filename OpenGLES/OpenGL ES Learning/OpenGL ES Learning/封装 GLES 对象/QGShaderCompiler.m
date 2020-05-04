//
//  QGShaderCompiler.m
//  OpenGL ES Learning
//
//  Created by QG on 2020/5/4.
//  Copyright © 2020 李超群. All rights reserved.
//

#import "QGShaderCompiler.h"

@implementation QGShaderCompiler{
    GLuint _program;
}

/** 直接使用字符串 */
- (instancetype)initWithvshader:(NSString *)vshader fshader:(NSString *)fshader{
    self = [super init];
    if (self) {
        [self compiltVshader:vshader fshader:fshader];
    }
    return self;
}

/** 使用文件 */
- (instancetype)initWithvshaderPath:(NSString *)vshaderPath fshaderPath:(NSString *)fshaderPath{
    NSString *vshaderString = [NSString stringWithContentsOfFile:vshaderPath encoding:NSUTF8StringEncoding error:nil];
    NSString *fshaderString = [NSString stringWithContentsOfFile:fshaderPath encoding:NSUTF8StringEncoding error:nil];
    return [self initWithvshader:vshaderString fshader:fshaderString];
}

/** 使用文件(后缀需要是.glsl) */
- (instancetype)initWithvshaderFileName:(NSString *)vshaderName fshaderFileName:(NSString *)fshaderName{
    NSString * vertextShaderPath = [[NSBundle mainBundle] pathForResource:vshaderName ofType:@"glsl"];
    NSString * fragmentShaderPath = [[NSBundle mainBundle] pathForResource:fshaderName ofType:@"glsl"];
    return [self initWithvshaderPath:vertextShaderPath fshaderPath:fragmentShaderPath];
}

/** 编译主色器程序 */
-(void)compiltVshader:(NSString *)vshader fshader:(NSString *)fshader{
    GLuint vertextShader = [GLESUtils loadShader:GL_VERTEX_SHADER withString:vshader];
    GLuint framegmentShader = [GLESUtils loadShader:GL_FRAGMENT_SHADER withString:fshader];
    
    _program = glCreateProgram();
    glAttachShader(_program, vertextShader);
    glAttachShader(_program, framegmentShader);
    
    // - 链接
    GLint status;
    glLinkProgram(_program);
    glGetProgramiv(_program, GL_LINK_STATUS, &status);
        
    // - 链接完成后释放
    if (status != GL_FALSE){
        glDeleteShader(vertextShader);
        vertextShader = 0;
        glDeleteShader(framegmentShader);
        framegmentShader = 0;

    }


}

/** 添加属性
// - 以下这种使用 glBindAttribLocation 的方法 ,需要在 glLinkProgram 函数之前调用; 如果在glLinkProgram 之后调用, 就会出现  glBindAttribLocation 中的 inedex 和 使用 glGetAttribLocation 获取的 index 的值不同的情况; 因为这个原因, 所以不使用 glBindAttribLocation 的方式了, 而是转而使用常规的 glGetAttribLocation 方式
- (GLuint)addAttribute:(NSString *)attributeName{
    NSUInteger index = [_attributes indexOfObject:attributeName];
    if (index == NSNotFound) {
        [_attributes addObject:attributeName];
        index = [_attributes indexOfObject:attributeName];
        glBindAttribLocation(_program, (GLuint)index, attributeName.UTF8String);
        glEnableVertexAttribArray((GLuint)index);
    }
    return (GLuint)index;
}

- (GLuint)attributeIndex:(NSString *)attributeName{
    GLuint index = (GLuint)[_attributes indexOfObject:attributeName];
    return index;
}
*/

/** 添加属性 */
- (GLuint)addAttribute:(NSString *)attributeName{
    GLuint index = glGetAttribLocation(_program, attributeName.UTF8String);
    glEnableVertexAttribArray(index);
    return index;
}


/** 使用着色器程序 */
-(void)glUseProgram{
    glUseProgram(_program);
}
@end
