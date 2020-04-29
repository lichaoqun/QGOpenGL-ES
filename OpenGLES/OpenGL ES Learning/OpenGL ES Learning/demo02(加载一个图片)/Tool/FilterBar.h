//
//  FilterBar.h
//  001--滤镜处理
//
//  Created by CC老师 on 2019/4/23.
//  Copyright © 2019年 CC老师. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterModel.h"
@class FilterBar;

@protocol FilterBarDelegate <NSObject>

- (void)filterBar:(FilterBar *)filterBar didSelectModel:(FilterModel *)model indexPath:(NSIndexPath *)indexPath;

@end


@interface FilterBar : UIView

@property (nonatomic, strong) NSArray <FilterModel *> *itemList;

@property (nonatomic, weak) id<FilterBarDelegate> delegate;

@end
