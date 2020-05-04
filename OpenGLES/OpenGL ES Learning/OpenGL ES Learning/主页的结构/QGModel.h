//
//  QGModel.h
//  QGFFmpeg
//
//  Created by QG on 2020/4/21.
//  Copyright © 2020 xinxianzhizao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface QGModel : NSObject

/** <#title#> */
@property(nonatomic, copy)NSString *title;

+(instancetype)createModelWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
