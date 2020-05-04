//
//  QGModel.m
//  QGFFmpeg
//
//  Created by QG on 2020/4/21.
//  Copyright © 2020 xinxianzhizao. All rights reserved.
//

#import "QGModel.h"

@implementation QGModel


+(instancetype)createModelWithTitle:(NSString *)title{
    QGModel *m = [[QGModel alloc]init];
    m.title = title;
    return m;
}

@end
