//
//  GLESUtils.m
//  OpenGL ES Learning
//
//  Created by 李超群 on 2019/1/24.
//  Copyright © 2019 李超群. All rights reserved.
//

#import "GLESUtils.h"

@implementation GLESUtils

+(GLuint)loadShader:(GLenum)type withFilepath:(NSString *)shaderFilepath{
    NSString *shaderString = [NSString stringWithContentsOfFile:shaderFilepath encoding:NSUTF8StringEncoding error:nil];
    return [self loadShader:type withString:shaderString];
}

+(GLuint)loadShader:(GLenum)type withString:(NSString *)shaderString{
    GLuint shader = glCreateShader(type);
    const char *shaderStringUTF8 = [shaderString UTF8String];
    glShaderSource(shader, 1, &shaderStringUTF8, NULL);
    glCompileShader(shader);
    
    GLint compileSuccess;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shader, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSAssert(NO, @"shader编译失败：%@", messageString);
        exit(1);
    }

    return shader;
}

@end

/*
 // 初始化着色器程序
 - (void)setupShaderProgramWithName:(NSString *)name {
     //1. 获取着色器program
     GLuint program = [self programWithShaderName:name];
     
     //2. use Program
     glUseProgram(program);
     
     //3. 获取Position,Texture,TextureCoords 的索引位置
     GLuint positionSlot = glGetAttribLocation(program, "Position");
     GLuint textureSlot = glGetUniformLocation(program, "Texture");
     GLuint textureCoordsSlot = glGetAttribLocation(program, "TextureCoords");
     
     //4.激活纹理,绑定纹理ID
     glActiveTexture(GL_TEXTURE0);
     glBindTexture(GL_TEXTURE_2D, self.textureID);
     
     //5.纹理sample
     glUniform1i(textureSlot, 0);
     
     //6.打开positionSlot 属性并且传递数据到positionSlot中(顶点坐标)
     glEnableVertexAttribArray(positionSlot);
     glVertexAttribPointer(positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(SenceVertex), NULL + offsetof(SenceVertex, positionCoord));
     
     //7.打开textureCoordsSlot 属性并传递数据到textureCoordsSlot(纹理坐标)
     glEnableVertexAttribArray(textureCoordsSlot);
     glVertexAttribPointer(textureCoordsSlot, 2, GL_FLOAT, GL_FALSE, sizeof(SenceVertex), NULL + offsetof(SenceVertex, textureCoord));
     
     //8.保存program,界面销毁则释放
     self.program = program;
 }

 
 //link Program
 - (GLuint)programWithShaderName:(NSString *)shaderName {
     //1. 编译顶点着色器/片元着色器
     GLuint vertexShader = [self compileShaderWithName:shaderName type:GL_VERTEX_SHADER];
     GLuint fragmentShader = [self compileShaderWithName:shaderName type:GL_FRAGMENT_SHADER];
     
     //2. 将顶点/片元附着到program
     GLuint program = glCreateProgram();
     glAttachShader(program, vertexShader);
     glAttachShader(program, fragmentShader);
     
     //3.linkProgram
     glLinkProgram(program);
     
     //4.检查是否link成功
     GLint linkSuccess;
     glGetProgramiv(program, GL_LINK_STATUS, &linkSuccess);
     if (linkSuccess == GL_FALSE) {
         GLchar messages[256];
         glGetProgramInfoLog(program, sizeof(messages), 0, &messages[0]);
         NSString *messageString = [NSString stringWithUTF8String:messages];
         NSAssert(NO, @"program链接失败：%@", messageString);
         exit(1);
     }
     //5.返回program
     return program;
 }

 
 //编译shader代码
 - (GLuint)compileShaderWithName:(NSString *)name type:(GLenum)shaderType {
     
     //1.获取shader 路径
     NSString *shaderPath = [[NSBundle mainBundle] pathForResource:name ofType:shaderType == GL_VERTEX_SHADER ? @"vsh" : @"fsh"];
     NSError *error;
     NSString *shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
     if (!shaderString) {
         NSAssert(NO, @"读取shader失败");
         exit(1);
     }
     
     //2. 创建shader->根据shaderType
     GLuint shader = glCreateShader(shaderType);
     
     //3.获取shader source
     const char *shaderStringUTF8 = [shaderString UTF8String];
     int shaderStringLength = (int)[shaderString length];
     glShaderSource(shader, 1, &shaderStringUTF8, &shaderStringLength);
     
     //4.编译shader
     glCompileShader(shader);
     
     //5.查看编译是否成功
     GLint compileSuccess;
     glGetShaderiv(shader, GL_COMPILE_STATUS, &compileSuccess);
     if (compileSuccess == GL_FALSE) {
         GLchar messages[256];
         glGetShaderInfoLog(shader, sizeof(messages), 0, &messages[0]);
         NSString *messageString = [NSString stringWithUTF8String:messages];
         NSAssert(NO, @"shader编译失败：%@", messageString);
         exit(1);
     }
     //6.返回shader
     return shader;
 }

 */
