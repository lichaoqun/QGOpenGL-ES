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

@interface QGViewController ()

@end

@implementation QGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];

}


-(void)testVideo{
    DYGiftEffectManager *mgr = [[DYGiftEffectManager alloc]initWithSuperView:self.view];
    for (int i = 0; i < 7; i++) {
        NSURL *url = [[NSBundle mainBundle]URLForResource:@"rocket" withExtension:@"mp4"];
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
            // - 分离文件中的 flv 和 aac 文件, 并写入到本地
            v = [[GLESView alloc]initWithFrame:viewRect];
            break;
        }
        case 1:{
            // - 播放文件
            v = [[GLESView1 alloc]initWithFrame:viewRect];
            break;
        }
        case 2:{
            // - 格式转换
            v = [[GLESView2 alloc]initWithFrame:viewRect];
            break;
        }
        case 3:{
            // - 裁剪视频
            v = [[GLESView3 alloc]initWithFrame:viewRect];
            break;
        }
        case 4:{
            // - 视频拼接
            v = [[GLESView4 alloc]initWithFrame:viewRect];

            break;
        }
        case 5:{
            // - 视频编码
            v = [[GLESView5 alloc]initWithFrame:viewRect];
            break;
        }
        case 6:{
            // - 显示视频
            [self testVideo];
            break;
        }

        case 7:{
            // - 显示视频
            v = [[GLESView7 alloc]initWithFrame:viewRect];
            break;
        }

        case 8:{
            // - 显示视频
                v = [[GLESView8 alloc]initWithFrame:viewRect];
            break;
        }

        case 9:{
            // - 显示视频
                v = [[GLESView9 alloc]initWithFrame:viewRect];
            break;
        }

        case 10:{
            // - 显示视频
        v = [[GLESView10 alloc]initWithFrame:viewRect];
            break;
        }
            
        default:
        break;
    
    }
    [self.view addSubview:v];
}

@end
