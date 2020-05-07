//
//  QGViewController1.m
//  OpenGL ES Learning
//
//  Created by 李超群 on 2020/5/7.
//  Copyright © 2020 李超群. All rights reserved.
//

#import "QGViewController1.h"
#import "QGInputImage.h"
#import "QGGrayscaleFilter.h"
#import "QGGLESView.h"

@implementation QGViewController1

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupFilter];
    }
    return self;
}

-(void)setupFilter{
    QGInputImage *inputImg = [[QGInputImage alloc]initWithImageName:@"gyy.jpg"];
    QGGrayscaleFilter *filter = [[QGGrayscaleFilter alloc]initWithSize:self.view.frame.size filterName:@"FragmentShader2_06"];
    QGGrayscaleFilter *filter1 = [[QGGrayscaleFilter alloc]initWithSize:self.view.frame.size filterName:@"FragmentShader2_04"];
    QGGrayscaleFilter *filter2 = [[QGGrayscaleFilter alloc]initWithSize:self.view.frame.size filterName:@"FragmentShader2_14"];
    QGGLESView *view = [[QGGLESView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    
    [inputImg addTarget:filter];
    [filter addTarget:filter1];
    [filter1 addTarget:filter2];
    [filter2 addTarget:view];
    
    [inputImg render];
    
}

@end
