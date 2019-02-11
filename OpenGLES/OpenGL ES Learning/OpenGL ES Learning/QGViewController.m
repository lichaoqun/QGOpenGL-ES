//
//  ViewController.m
//  LearnOpenGLES
//
//  Created by 李超群 on 2019/1/24.
//  Copyright © 2019 loyinglin. All rights reserved.
//

#import "QGViewController.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

@interface QGViewController ()

@end

@implementation QGViewController{
    EAGLContext *_eaglContext;
    GLKBaseEffect *_effect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupConfig];
    [self uploadVertexArryay];
    [self uploadTexture];

 }

-(void)setupConfig{
    _eaglContext = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!_eaglContext) return;
    GLKView *view =  (GLKView *)self.view;
    view.context = _eaglContext;
    
    // - 色彩空间 rgba 每个颜色用8位表示
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    
    // - 绘制深度
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:_eaglContext];
    glEnable(GL_DEPTH_TEST);
    
    // - 先用 reba(0,0,0,1) 清理画布
    glClearColor(0, 0, 0, 1);
}

-(void)uploadVertexArryay{
    GLfloat vertextData[] = {
        0.5f, -0.5f, 0.0f,  1.0f,0.0f,
        0.5f, 0.5f, 0.0f,   1.0f, 0.0f,
        -0.5f, 0.5f, 0.0f,  0.0f, 1.0f,

        0.5f, -0.5f, 0.0f,  1.0f,0.0f,
        -0.5f, 0.5f, 0.0f,  0.0f, 1.0f,
        -0.5f, -0.5f, 0.0f, 0.0f, 0.0f,
    };
    
    // - 缓冲区
    GLuint buffer;
    
    // - 申请一个缓冲区标识符
    glGenBuffers(1, &buffer);
    
    // - 确定这缓冲区是用来做什么的(这里是用来装顶点数组的)
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    
    // - 把顶点数据从 cpu 复制到 gpu
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertextData), vertextData, GL_STATIC_DRAW);
    
    // - 读取顶点数据 交给 GLKVertexAttribPosition
    glEnable(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GL_FLOAT) * 5, (GLfloat *)NULL);
    
    // - 读取纹理数据 交给 GLKVertexAttribTexCoord0
    glEnable(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GL_FLOAT) * 5, (GLfloat *)NULL +  3);
}


-(void)uploadTexture{
    // - 1.获取纹理路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"wall" ofType:@"jpg"];
    
    // - 读取纹理的方式
    NSDictionary *options = @{GLKTextureLoaderOriginBottomLeft : @(1)};
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    
    // - 着色器
    _effect = [[GLKBaseEffect alloc]init];
    _effect.texture2d0.enabled = YES;
    _effect.texture2d0.name = textureInfo.name;
}

@end
