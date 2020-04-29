//
//  FilterModel.h
//  OpenGL ES Learning
//
//  Created by QG on 2020/4/29.
//  Copyright © 2020 李超群. All rights reserved.
//

#import <Foundation/Foundation.h>

// - MARK: <-- 通用的 model -->
@interface FilterModel : NSObject

/** 美颜的标题 */
@property (nonatomic, copy) NSString *filterTitle;

/** 美颜的 shader */
@property (nonatomic, copy) NSString *filterShader;

/** 暂停特效 */
-(void)stopLastFilter;

+(NSArray <FilterModel *> *)filterModels;
@end

// - MARK: <-- 基础的filter model -->
@interface FilterNormalModel : FilterModel

+(instancetype)filterModelWithTitle:(NSString *)title shader:(NSString *)shader;

@end

// - MARK: <-- 图片混合的filter model -->
@interface FilterImageModel : FilterModel

/** 混合的图片 */
@property (nonatomic, copy) NSString *filterImageName;

+(instancetype)filterModelWithTitle:(NSString *)title shader:(NSString *)shader filterImageName:(NSString *)filterImageName;

@end

// - MARK: <-- 动态的的filter model -->
@interface FilterAnimationModel : FilterModel

/** 动画数组 */
@property(nonatomic, strong)NSArray *animations;

+(instancetype)filterModelWithTitle:(NSString *)title shader:(NSString *)shader animations:(NSArray *)animations;

- (void)callbackImageName:(void (^) (NSString *imgName))callback;
@end

