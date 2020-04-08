//
//  UIView+XYLayerColor.m
//  XYLayerColor
//
//  Created by RayJiang on 2019/7/18.
//  Copyright © 2019 RayJiang. All rights reserved.
//

#import "UIView+XYLayerColor.h"
#import "_XYColor_PrivateView.h"

@implementation UIView (XYLayerColor)

- (void)xy_setLayerBorderColor:(UIColor *)color
{
#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *))
    {
        if (self.pv == nil)
        {
            self.pv = [_XYColor_PrivateView new];
        }
        __weak UIView *weakView = self;
        [self.pv traitCollectionChange:^{
            __strong UIView *view = weakView;
            view.layer.borderColor = [color resolvedColorWithTraitCollection:view.traitCollection].CGColor;
        }];
        self.layer.borderColor = [color resolvedColorWithTraitCollection:self.traitCollection].CGColor;
    } else
    {
        self.layer.borderColor = color.CGColor;
    }
#else
    self.layer.borderColor = color.CGColor;
#endif
}

- (void)xy_setLayerShadowColor:(UIColor *)color
{
#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *))
    {
        if (self.pv == nil)
        {
            self.pv = [_XYColor_PrivateView new];
        }
        __weak UIView *weakView = self;
        [self.pv traitCollectionChange:^{
            __strong UIView *view = weakView;
            view.layer.shadowColor = [color resolvedColorWithTraitCollection:view.traitCollection].CGColor;
        }];
        self.layer.shadowColor = [color resolvedColorWithTraitCollection:self.traitCollection].CGColor;
    } else
    {
        self.layer.shadowColor = color.CGColor;
    }
#else
    self.layer.shadowColor = color.CGColor;
#endif
}

- (void)xy_setLayerBackgroundColor:(UIColor *)color
{
#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *))
    {
        if (self.pv == nil) {
            self.pv = [_XYColor_PrivateView new];
        }
        __weak UIView *weakView = self;
        [self.pv traitCollectionChange:^{
            __strong UIView *view = weakView;
            view.layer.backgroundColor = [color resolvedColorWithTraitCollection:view.traitCollection].CGColor;
        }];
        self.layer.backgroundColor = [color resolvedColorWithTraitCollection:self.traitCollection].CGColor;
    } else
    {
        self.layer.backgroundColor = color.CGColor;
    }
#else
    self.layer.backgroundColor = color.CGColor;
#endif
}

@end
