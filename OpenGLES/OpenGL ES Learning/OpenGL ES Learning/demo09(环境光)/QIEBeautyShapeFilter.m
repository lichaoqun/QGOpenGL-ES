//
//  QIEBeautyShapeFilter.m
//  QGPusher
//
//  Created by 李超群 on 2020/12/24.
//  Copyright © 2020 李超群. All rights reserved.
//

//#import "QIEBeautyShapeFilter.h"
//#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
//NSString *const kGPUImageBeautyShapeFragmentShaderString = SHADER_STRING(
//   precision highp float;
//   struct GLEdgeInsets {
//        float left;
//        float right;
//        float top;
//        float bottom;
//     };
//
//    varying highp vec2 textureCoordinate;
//    uniform sampler2D inputImageTexture;
//    uniform GLEdgeInsets edg;
//
//    void main(){
//        if(textureCoordinate.x > edg.left &&
//           textureCoordinate.x < edg.right &&
//           textureCoordinate.y > edg.top  &&
//           textureCoordinate.y < edg.bottom){
//            gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
//                return;
//            }
//        gl_FragColor = vec4(0.1, 0.5, 0.3, 1.0);
//    }
//);
//#endif
//
//@implementation QIEBeautyShapeFilter
//
//- (id)init{
//    if (!(self = [super initWithFragmentShaderFromString:kGPUImageBeautyShapeFragmentShaderString])) {
//        return nil;
//    }
//    return self;
//}
//
//-(void)setl:(float)l r:(float)r t:(float)t b:(float)b{
//    [self setFloat:l forUniformName:@"edg.left"];
//    [self setFloat:r forUniformName:@"edg.right"];
//    [self setFloat:t forUniformName:@"edg.top"];
//    [self setFloat:b forUniformName:@"edg.bottom"];
//
//}
//@end


#import "QIEBeautyShapeFilter.h"
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE

NSString *const kGPUImageFaceFeatureVertexShaderString = SHADER_STRING
(
 precision highp float;
 
 attribute vec4 position;
 attribute vec4 inputTextureCoordinate;
 
 varying vec2 textureCoordinate;
 
 uniform float pointSize;
 
 void main()
 {
     gl_Position = position;
     gl_PointSize = pointSize;
     textureCoordinate = inputTextureCoordinate.xy;
 }
);

NSString *const kGPUImageFaceFeatureFragmentShaderString = SHADER_STRING
(
 precision highp float;
 
 varying vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 uniform int isPoint;
 
 void main()
 {
     if (isPoint != 0) {
         gl_FragColor = vec4(0.0, 1.0, 0.0, 1.0);
     } else {
         gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
     }
 }
);
#endif

@interface QIEBeautyShapeFilter ()
@property (nonatomic, assign) GLint isPointUniform;
@property (nonatomic, assign) GLint pointSizeUniform;
@end

@implementation QIEBeautyShapeFilter

- (instancetype)init {
    self = [super initWithVertexShaderFromString:kGPUImageFaceFeatureVertexShaderString
                        fragmentShaderFromString:kGPUImageFaceFeatureFragmentShaderString];
    if (self) {
        self.isPointUniform = [filterProgram uniformIndex:@"isPoint"];
        self.pointSizeUniform = [filterProgram uniformIndex:@"pointSize"];
    }
    return self;
}

- (void)renderToTextureWithVertices:(const GLfloat *)vertices
                 textureCoordinates:(const GLfloat *)textureCoordinates {
    if (self.preventRendering)
    {
        [firstInputFramebuffer unlock];
        return;
    }
    
    [GPUImageContext setActiveShaderProgram:filterProgram];
    
    outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:[self sizeOfFBO] textureOptions:self.outputTextureOptions onlyTexture:NO];
    [outputFramebuffer activateFramebuffer];
    if (usingNextFrameForImageCapture)
    {
        [outputFramebuffer lock];
    }
    
    [self setUniformsForProgramAtIndex:0];
    // - 先绘制上边接收到的纹理
    glClearColor(backgroundColorRed, backgroundColorGreen, backgroundColorBlue, backgroundColorAlpha);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, [firstInputFramebuffer texture]);
    
    glUniform1i(filterInputTextureUniform, 2);
    glUniform1i(self.isPointUniform, 0);    // 表示是绘制纹理
    
    glVertexAttribPointer(filterPositionAttribute, 2, GL_FLOAT, 0, 0, vertices);
    glVertexAttribPointer(filterTextureCoordinateAttribute, 2, GL_FLOAT, 0, 0, textureCoordinates);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    // - 再绘制点
    GLfloat facesPoints[] =  {0.0,0.1,
                            0.0,0.2,
                            0.0,0.3,
                            0.0,0.4
    };
    
    glUniform1i(self.isPointUniform, 1);    // 表示是绘制点
    glUniform1f(self.pointSizeUniform, self.sizeOfFBO.width * 0.006);  // 设置点的大小
    glVertexAttribPointer(filterPositionAttribute, 2, GL_FLOAT, 0, 0, facesPoints);
    glDrawArrays(GL_POINTS, 0, sizeof(facesPoints) / sizeof(GLfloat) / 2);

    [firstInputFramebuffer unlock];
    
    if (usingNextFrameForImageCapture)
    {
        dispatch_semaphore_signal(imageCaptureSemaphore);
    }
    
    // - 在shader中, 第一次进入片元着色器的时候, ispoint = 0, 此时的shader 绘制的是纹理的图片;
    // - 在shader中, 第二次进入片元着色器的时候, ispoint = 1, 此时的shader 绘制的是点;
}
-(void)setl:(float)l r:(float)r t:(float)t b:(float)b{
    
}

@end
