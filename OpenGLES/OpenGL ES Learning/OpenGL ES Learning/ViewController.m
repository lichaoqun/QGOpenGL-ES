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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad]; 
    // Do any additional setup after loading the view, typically from a nib.
  
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.view.backgroundColor = [UIColor whiteColor];
    //    GLESView *v = [[GLESView alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 300)];
    //    GLESView1 *v = [[GLESView1 alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 300)];
    //    GLESView2 *v = [[GLESView2 alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //    GLESView3 *v = [[GLESView3 alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //    GLESView4 *v = [[GLESView4 alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //    GLESView5 *v = [[GLESView5 alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

        GLESView7 *v = [[GLESView7 alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //    GLESView8 *v = [[GLESView8 alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //    GLESView9 *v = [[GLESView9 alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //    GLESView10 *v = [[GLESView10 alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:v];
}
@end
