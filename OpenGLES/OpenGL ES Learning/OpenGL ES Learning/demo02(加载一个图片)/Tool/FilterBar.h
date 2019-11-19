//
//  FilterBar.h
//  001--滤镜处理
//
//  Created by CC老师 on 2019/4/23.
//  Copyright © 2019年 CC老师. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterBar, FilterModel;

@protocol FilterBarDelegate <NSObject>

- (void)filterBar:(FilterBar *)filterBar didSelectModel:(FilterModel *)model indexPath:(NSIndexPath *)indexPath;

@end


@interface FilterModel : NSObject

/** 美颜的标题 */
@property (nonatomic, copy) NSString *filterTitle;

/** 美颜的 shader */
@property (nonatomic, copy) NSString *filterShader;

+(instancetype)filterModelWithTitle:(NSString *)title shader:(NSString *)shader;

@end


@interface FilterBar : UIView

@property (nonatomic, strong) NSArray <FilterModel *> *itemList;

@property (nonatomic, weak) id<FilterBarDelegate> delegate;

@end
