//
//  LYGLViewController.m
//  LearnOpenGLES
//
//  Created by loyinglin on 16/3/16.
//  Copyright © 2016年 loyinglin. All rights reserved.
//

#import "LYGLViewController.h"
#import "LearnView.h"

@interface LYGLViewController ()
@property (nonatomic , strong) LearnView*   myView;
@property (nonatomic, strong) CADisplayLink* mDisplayLink;
@end

@implementation LYGLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myView = (LearnView *)self.view;
    [self.myView customInit];
    [self.myView update];
    
//    self.mDisplayLink = [CADisplayLink displayLinkWithTarget:self.myView selector:@selector(update)];
//    [self.mDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
