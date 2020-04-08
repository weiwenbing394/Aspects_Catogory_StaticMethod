//
//  UIView+XYLayerColor.h
//  XYLayerColor
//
//  Created by RayJiang on 2019/7/18.
//  Copyright © 2019 RayJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (XYLayerColor)

- (void)xy_setLayerBorderColor:(UIColor *)color;
- (void)xy_setLayerShadowColor:(UIColor *)color;
- (void)xy_setLayerBackgroundColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
