//
//  QGViewController1.m
//  OpenGL ES Learning
//
//  Created by 李超群 on 2020/5/7.
//  Copyright © 2020 李超群. All rights reserved.
//

#import "QGViewController1.h"
#import "QGInputImage.h"
#import "QGNormalFilter.h"
#import "QGGLESView.h"

@interface QGViewController1()

//@property (nonatomic, strong) QGInputImage *inputImg;
//@property (nonatomic, strong) QGGLESView *renderView;

@end

@implementation QGViewController1

-(void)viewDidLoad{
    self.view.backgroundColor = [UIColor redColor];
    [self setupFilter];
}


-(void)setupFilter{
     QGInputImage *inputImg = [[QGInputImage alloc]initWithImageName:@"gyy.jpg"];
    QGGLESView *renderView = [[QGGLESView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:renderView];
    
    [inputImg setFilters:@[
        [[QGNormalFilter alloc]initWithSize:self.view.frame.size filterName:@"FragmentShader2_06"],
        [[QGNormalFilter alloc]initWithSize:self.view.frame.size filterName:@"FragmentShader2_04"],
        [[QGNormalFilter alloc]initWithSize:self.view.frame.size filterName:@"FragmentShader2_14"],
    ]];
    [inputImg startRenderInView:renderView];

}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    static int flag = 0;
//    self.inputImg = [[QGInputImage alloc]initWithImageName:@"gyy.jpg"];
//    NSArray *array = [NSArray array];
//    switch (flag % 3) {
//        case 0:
//            array = @[
//                [[QGNormalFilter alloc]initWithSize:self.view.frame.size filterName:@"FragmentShader2_06"],
//            ];
//
//            break;
//
//        case 1:
//        array = @[
//            [[QGNormalFilter alloc]initWithSize:self.view.frame.size filterName:@"FragmentShader2_04"],
//            [[QGNormalFilter alloc]initWithSize:self.view.frame.size filterName:@"FragmentShader2_14"],
//        ];
//            break;
//
//        case 2:
//        array = @[
//            [[QGNormalFilter alloc]initWithSize:self.view.frame.size filterName:@"FragmentShader2_06"],
//            [[QGNormalFilter alloc]initWithSize:self.view.frame.size filterName:@"FragmentShader2_04"],
//            [[QGNormalFilter alloc]initWithSize:self.view.frame.size filterName:@"FragmentShader2_14"],
//        ];
//            break;
//
//        default:
//            break;
//    }
//
//    [self.inputImg setFilters:array];
//    [self.inputImg startRenderInView:self.renderView];
//    flag++;
//}

@end
