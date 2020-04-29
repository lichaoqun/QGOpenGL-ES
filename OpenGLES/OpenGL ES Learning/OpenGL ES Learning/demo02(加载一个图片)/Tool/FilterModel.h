//
//  FilterModel.h
//  OpenGL ES Learning
//
//  Created by QG on 2020/4/29.
//  Copyright © 2020 李超群. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FilterModel : NSObject

/** 美颜的标题 */
@property (nonatomic, copy) NSString *filterTitle;

/** 美颜的 shader */
@property (nonatomic, copy) NSString *filterShader;

/** 美颜的 shader */
@property (nonatomic, copy) NSString *filterImageName;

+(instancetype)filterModelWithTitle:(NSString *)title shader:(NSString *)shader;

+(instancetype)filterModelWithTitle:(NSString *)title shader:(NSString *)shader filterImageName:(NSString *)filterImageName;

+(NSArray <FilterModel *> *)filterModels;
@end

NS_ASSUME_NONNULL_END
