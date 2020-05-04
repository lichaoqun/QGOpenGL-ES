//
//  DYGestureRecognizerView.m
//  OpenGL ES Learning
//
//  Created by 李超群 on 2019/2/15.
//  Copyright © 2019 李超群. All rights reserved.
//

#import "DYGestureRecognizerView.h"

@implementation DYGestureRecognizerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scale = 1;
        [self addGestureRecognizer];
    }
    return self;
}

-(void)setScale:(CGFloat)scale{
    _scale = scale;
    [self updateRender];
}

-(void)setRote:(DYRote)rote{
    _rote = rote;
    [self updateRender];
}

/** 更新绘制 */
-(void)updateRender{
    
}

-(void)addGestureRecognizer{
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self addGestureRecognizer:pinchGestureRecognizer];
    
    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self addGestureRecognizer:panGestureRecognizer];
}

- (void)pinchView:(UIPinchGestureRecognizer*)sender {
    CGFloat scale = 0;
    if (sender.state == UIGestureRecognizerStateChanged) {
        scale = ([sender scale] - 1.0) / 2;
        self.scale = MAX(1,  MIN(self.scale + scale, 3));
    }
}

-(void)panView:(UIPanGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateChanged){
        CGPoint currentPoint = [sender translationInView:self];
        CGFloat x = (currentPoint.x  * -1) / self.frame.size.width;
        CGFloat y =   (currentPoint.y * -1) / self.frame.size.width;
        DYRote rote = {(x * 20) + self.rote.roteX , (y  * 20) + self.rote.roteY};
        self.rote = rote;
    }
}


@end
