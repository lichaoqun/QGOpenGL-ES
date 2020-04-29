//
//  FilterModel.m
//  OpenGL ES Learning
//
//  Created by QG on 2020/4/29.
//  Copyright © 2020 李超群. All rights reserved.
//

#import "FilterModel.h"

@implementation FilterModel

+(instancetype)filterModelWithTitle:(NSString *)title shader:(NSString *)shader{
    return [self filterModelWithTitle:title shader:shader filterImageName:nil];
}


+(instancetype)filterModelWithTitle:(NSString *)title shader:(NSString *)shader filterImageName:(NSString *)filterImageName{
    FilterModel *model = [[FilterModel alloc]init];
    model.filterTitle = title;
    model.filterShader = shader;
    model.filterImageName = filterImageName;
    return model;
}

+(NSArray <FilterModel *> *)filterModels{
    static NSArray <FilterModel *> *arrayList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
         arrayList = @[
            [FilterModel filterModelWithTitle:@"普通" shader:@"FragmentShader2_00"],
            [FilterModel filterModelWithTitle:@"二分原比例" shader:@"FragmentShader2_01"],
            [FilterModel filterModelWithTitle:@"三分原比例" shader:@"FragmentShader2_02"],
            [FilterModel filterModelWithTitle:@"四分压缩" shader:@"FragmentShader2_03"],
            [FilterModel filterModelWithTitle:@"九分原比例" shader:@"FragmentShader2_04"],
            [FilterModel filterModelWithTitle:@"九分压缩" shader:@"FragmentShader2_05"],
            [FilterModel filterModelWithTitle:@"黑白色" shader:@"FragmentShader2_06"],
            [FilterModel filterModelWithTitle:@"黑白分屏缩放1" shader:@"FragmentShader2_07"],
            [FilterModel filterModelWithTitle:@"黑白分屏缩放2" shader:@"FragmentShader2_08"],
            [FilterModel filterModelWithTitle:@"黑白上下颠倒" shader:@"FragmentShader2_09"],
            [FilterModel filterModelWithTitle:@"黑白模糊分屏缩放" shader:@"FragmentShader2_10"],
            [FilterModel filterModelWithTitle:@"滤镜1" shader:@"FragmentShader2_11" filterImageName:@"lookup"],
            [FilterModel filterModelWithTitle:@"滤镜2" shader:@"FragmentShader2_11" filterImageName:@"lookup_amatorka"],
            [FilterModel filterModelWithTitle:@"滤镜3" shader:@"FragmentShader2_11" filterImageName:@"lookup_miss_etikate"],
            [FilterModel filterModelWithTitle:@"滤镜4" shader:@"FragmentShader2_11" filterImageName:@"lookup_soft_elegance_1"],
            [FilterModel filterModelWithTitle:@"滤镜5" shader:@"FragmentShader2_11" filterImageName:@"lookup_soft_elegance_2"],
            [FilterModel filterModelWithTitle:@"动画水印" shader:@"FragmentShader2_12"],
        ];
    });
    return arrayList;
}
@end
