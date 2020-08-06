//
//  QGViewController.m
//  OpenGL ES Learning
//
//  Created by QG on 2020/4/28.
//  Copyright © 2020 李超群. All rights reserved.
//

#import "QGViewController.h"
#import "GLESView.h"
#import "GLESView1.h"
#import "GLESView2.h"
#import "GLESView3.h"
#import "GLESView4.h"
#import "GLESView5.h"
#import "GLESView7.h"
#import "GLESView8.h"
#import "GLESView9.h"
#import "GLESView10.h"
#import "DYGiftEffectManager.h"
#import "QGDemo01.h"
#import "QGGPUImge.h"

@interface QGViewController ()

@end

@implementation QGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];

}


-(void)testVideo{
    self.view.backgroundColor = [UIColor redColor];
    DYGiftEffectManager *mgr = [[DYGiftEffectManager alloc]initWithSuperView:self.view];
    for (int i = 0; i < 7; i++) {
        NSURL *url = [[NSBundle mainBundle]URLForResource:@"ceshi" withExtension:@"mp4"];
        AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:url];
        [mgr pushItem:item];
    }
}

-(void)setType:(NSInteger)type{
    UIView *v;
    CGFloat topY = 80;
    CGRect viewRect = CGRectMake(0, topY, self.view.frame.size.width, self.view.frame.size.height - topY);
    switch (type) {
        case 0:{
            // - 绘制三角形状
            v = [[GLESView alloc]initWithFrame:viewRect];
            break;
        }
        case 1:{
            // - 正方形渐变
            v = [[GLESView1 alloc]initWithFrame:viewRect];
            break;
        }
        case 2:{
            // - 加载图片
            v = [[GLESView2 alloc]initWithFrame:viewRect];
            break;
        }
        case 3:{
            // - 两个图片纹理混合
            v = [[GLESView3 alloc]initWithFrame:viewRect];
            break;
        }
        case 4:{
            // - 正方体五个面相同
            v = [[GLESView4 alloc]initWithFrame:viewRect];

            break;
        }
        case 5:{
            // - 正方体五个面不同
            v = [[GLESView5 alloc]initWithFrame:viewRect];
            break;
        }
        case 6:{
            // - 加载视频
            [self testVideo];
            break;
        }
        case 7:{
            // - 3D立体球体
            v = [[GLESView7 alloc]initWithFrame:viewRect];
            break;
        }
        case 8:{
            // - 3D 贴图
            v = [[GLESView8 alloc]initWithFrame:viewRect];
            break;
        }
        case 9:{
            // - 3D材质, 环境光
            v = [[GLESView9 alloc]initWithFrame:viewRect];
            break;
        }
        case 10:{
            // - 光照+贴图
            v = [[GLESView10 alloc]initWithFrame:viewRect];
            break;
        }
        case 11:{
            
            // - 封装的滤镜
            QGInputImage *inputImg = [[QGInputImage alloc]initWithImageName:@"gyy.jpg"];
            v = [[QGGLESView alloc]initWithFrame:self.view.bounds];

            [inputImg setFilters:@[
                [[QGWhiteAndBlack alloc]initWithSize:self.view.frame.size],
                [[QGBaoHeDu alloc]initWithSize:self.view.frame.size],
                [[QGSeWen alloc]initWithSize:self.view.frame.size],
            ]];
            [inputImg startRenderInView:v];
            break;
        }
        default:
        break;
    
    }
    [self.view addSubview:v];
}

@end
