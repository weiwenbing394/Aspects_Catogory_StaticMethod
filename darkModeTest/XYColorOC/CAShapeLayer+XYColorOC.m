//
//  CAShapeLayer+XYColorOC.m
//  iIndustrial
//
//  Created by 魏文彬 on 2020/3/23.
//

#import "CAShapeLayer+XYColorOC.h"
#import "_XYColor_PrivateView.h"

@implementation CAShapeLayer (XYColorOC)

- (void)xy_setLayerStrokeColor:(UIColor *)color withView:(UIView *)view
{
    if (@available(iOS 13.0, *))
    {
        if (view.pv == nil) {
            view.pv = [_XYColor_PrivateView new];
            
        }
        __weak CAShapeLayer *weakLayer = self;
        [view.pv traitCollectionChange:^{
            weakLayer.strokeColor = [color resolvedColorWithTraitCollection:view.traitCollection].CGColor;
        }];
        self.strokeColor = [color resolvedColorWithTraitCollection:view.traitCollection].CGColor;
    } else
    {
        self.strokeColor = color.CGColor;
    }
};

@end
