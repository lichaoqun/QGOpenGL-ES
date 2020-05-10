//
//  QGNormalFilters.m
//  OpenGL ES Learning
//
//  Created by 李超群 on 2020/5/10.
//  Copyright © 2020 李超群. All rights reserved.
//

#import "QGNormalFilters.h"
@implementation QGThree
- (instancetype)initWithSize:(CGSize)renderSize{
    return [super initWithSize:renderSize filterName:@"FragmentShader2_02"];
}
@end

@implementation QGWhiteAndBlack
- (instancetype)initWithSize:(CGSize)renderSize{
    return [super initWithSize:renderSize filterName:@"FragmentShader2_08"];
}
@end

@implementation QGBaoHeDu
- (instancetype)initWithSize:(CGSize)renderSize{
    return [super initWithSize:renderSize filterName:@"FragmentShader2_13"];
}
@end

@implementation QGSeWen
- (instancetype)initWithSize:(CGSize)renderSize{
    return [super initWithSize:renderSize filterName:@"FragmentShader2_14"];
}
@end
