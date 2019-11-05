//
//  ViewController.m
//  OpenGL ES Learning
//
//  Created by 李超群 on 2019/1/24.
//  Copyright © 2019 李超群. All rights reserved.
//

#import "ViewController.h"
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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad]; 
    // Do any additional setup after loading the view, typically from a nib.
    
    
      self.view.backgroundColor = [UIColor whiteColor];
      //    GLESView *v = [[GLESView alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 300)];
  //        GLESView1 *v = [[GLESView1 alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 300)];
      //    GLESView2 *v = [[GLESView2 alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
      //    GLESView3 *v = [[GLESView3 alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
          GLESView4 *v = [[GLESView4 alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
      //    GLESView5 *v = [[GLESView5 alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

  //        GLESView7 *v = [[GLESView7 alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
      //    GLESView8 *v = [[GLESView8 alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
      //    GLESView9 *v = [[GLESView9 alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
      //    GLESView10 *v = [[GLESView10 alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
      [self.view addSubview:v];
  //    [self testVideo];


}
-(void)testVideo{
    DYGiftEffectManager *mgr = [[DYGiftEffectManager alloc]initWithSuperView:self.view];
    for (int i = 0; i < 7; i++) {
        NSURL *url = [[NSBundle mainBundle]URLForResource:@"guanjun" withExtension:@"mp4"];
        AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:url];
        [mgr pushItem:item];
    }
}
@end
