//
//  FilterModel.m
//  OpenGL ES Learning
//
//  Created by QG on 2020/4/29.
//  Copyright © 2020 李超群. All rights reserved.
//

#import "FilterModel.h"

@implementation FilterModel
/** 暂停特效 */
-(void)stopLastFilter{
    
}

+(NSArray <FilterModel *> *)filterModels{
    static NSArray <FilterModel *> *arrayList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
         arrayList = @[
            [FilterNormalModel filterModelWithTitle:@"普通" shader:@"FragmentShader2_00"],
            [FilterNormalModel filterModelWithTitle:@"二分原比例" shader:@"FragmentShader2_01"],
            [FilterNormalModel filterModelWithTitle:@"三分原比例" shader:@"FragmentShader2_02"],
            [FilterNormalModel filterModelWithTitle:@"四分压缩" shader:@"FragmentShader2_03"],
            [FilterNormalModel filterModelWithTitle:@"九分原比例" shader:@"FragmentShader2_04"],
            [FilterNormalModel filterModelWithTitle:@"九分压缩" shader:@"FragmentShader2_05"],
            [FilterNormalModel filterModelWithTitle:@"黑白色" shader:@"FragmentShader2_06"],
            [FilterNormalModel filterModelWithTitle:@"黑白分屏缩放1" shader:@"FragmentShader2_07"],
            [FilterNormalModel filterModelWithTitle:@"黑白分屏缩放2" shader:@"FragmentShader2_08"],
            [FilterNormalModel filterModelWithTitle:@"黑白上下颠倒" shader:@"FragmentShader2_09"],
            [FilterNormalModel filterModelWithTitle:@"黑白模糊分屏缩放" shader:@"FragmentShader2_10"],
            [FilterImageModel filterModelWithTitle:@"滤镜1" shader:@"FragmentShader2_11" filterImageName:@"lookup"],
            [FilterImageModel filterModelWithTitle:@"滤镜2" shader:@"FragmentShader2_11" filterImageName:@"lookup_amatorka"],
            [FilterImageModel filterModelWithTitle:@"滤镜3" shader:@"FragmentShader2_11" filterImageName:@"lookup_miss_etikate"],
            [FilterImageModel filterModelWithTitle:@"滤镜4" shader:@"FragmentShader2_11" filterImageName:@"lookup_soft_elegance_1"],
            [FilterImageModel filterModelWithTitle:@"滤镜5" shader:@"FragmentShader2_11" filterImageName:@"lookup_soft_elegance_2"],
            [FilterAnimationModel filterModelWithTitle:@"动画水印" shader:@"FragmentShader2_12" animations:@[@"01", @"02", @"03", @"04", @"05", @"06", @"07"]],
        ];
    });
    return arrayList;
}

@end

// - MARK: <-- 基础的filter model -->
@implementation FilterNormalModel

+(instancetype)filterModelWithTitle:(NSString *)title shader:(NSString *)shader{
    FilterNormalModel *model = [[FilterNormalModel alloc]init];
    model.filterTitle = title;
    model.filterShader = shader;
    return model;
}

@end

// - MARK: <-- 图片混合的filter model -->
@implementation FilterImageModel

+(instancetype)filterModelWithTitle:(NSString *)title shader:(NSString *)shader filterImageName:(NSString *)filterImageName{
    FilterImageModel *model = [[FilterImageModel alloc]init];
    model.filterTitle = title;
    model.filterShader = shader;
    model.filterImageName = filterImageName;
    return model;
}

@end

// - MARK: <-- 动态的的filter model -->
@interface FilterAnimationModel ()

@property(nonatomic, copy)void (^callback) (NSString *imgName);

/** <#title#> */
@property(nonatomic, strong)NSTimer *timer;

@end
@implementation FilterAnimationModel

+(instancetype)filterModelWithTitle:(NSString *)title shader:(NSString *)shader animations:(NSArray *)animations{
    FilterAnimationModel *model = [[FilterAnimationModel alloc]init];
    model.filterTitle = title;
    model.filterShader = shader;
    model.animations = animations;
    return model;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateTextureIndex2) userInfo:nil repeats:YES];
        [self.timer setFireDate:[NSDate distantFuture]];
    }
    return self;
}

-(void)updateTextureIndex2{
    static int idx = 0;
    idx = idx % self.animations.count;
    !self.callback ?: self.callback(self.animations[idx]);
    idx++;
}

- (void)callbackImageName:(void (^) (NSString *imgName))callback{
    [self.timer setFireDate:[NSDate distantPast]];
    self.callback = callback;
}

-(void)stopLastFilter{
    [self.timer setFireDate:[NSDate distantFuture]];
}

@end
