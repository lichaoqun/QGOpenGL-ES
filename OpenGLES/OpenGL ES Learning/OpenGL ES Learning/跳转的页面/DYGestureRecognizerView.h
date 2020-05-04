//
//  DYGestureRecognizerView.h
//  OpenGL ES Learning
//
//  Created by 李超群 on 2019/2/15.
//  Copyright © 2019 李超群. All rights reserved.
//

#import <UIKit/UIKit.h>

struct DYRote {
    CGFloat roteX;
    CGFloat roteY;
};

typedef struct DYRote DYRote;

@interface DYGestureRecognizerView : UIView

/** 缩放 */
@property (nonatomic, assign) CGFloat scale;

/** 旋转角度 */
@property (nonatomic, assign) DYRote rote;

/** 更新绘制 */
-(void)updateRender;

@end
