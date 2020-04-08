//
//  DarkModeLoadFile.m
//  darkModeTest
//
//  Created by 魏文彬 on 2020/4/2.
//  Copyright © 2020 XW. All rights reserved.
//

#import "DarkModeLoadFile.h"

#import <objc/runtime.h>

@implementation DarkModeLoadFile

+ (void)load
{
    [self fixResizableImage];
}

+ (UITraitCollection *)darkTrait API_AVAILABLE(ios(13.0)){
    static UITraitCollection *dTrait = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dTrait = [UITraitCollection traitCollectionWithTraitsFromCollections:@[
            [UITraitCollection traitCollectionWithDisplayScale:UIScreen.mainScreen.scale],
            [UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleDark]
        ]];
    });
     return dTrait;
}

+ (UITraitCollection *)lightTrait API_AVAILABLE(ios(13.0)){
    static UITraitCollection *unTrait = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        unTrait = [UITraitCollection traitCollectionWithTraitsFromCollections:@[
            [UITraitCollection traitCollectionWithDisplayScale:UIScreen.mainScreen.scale],
            [UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleLight]
        ]];
    });
     return unTrait;
}

+ (void)fixResizableImage API_AVAILABLE(ios(13.0)) {
    Class klass = UIImage.class;
    SEL selector = @selector(resizableImageWithCapInsets:resizingMode:);
    Method method = class_getInstanceMethod(klass, selector);
    if (method == NULL)
    {
        return;
    }

    IMP originalImp = class_getMethodImplementation(klass, selector);
    if (!originalImp)
    {
        return;
    }

    IMP dynamicColorCompatibleImp = imp_implementationWithBlock(^UIImage *(UIImage *_self, UIEdgeInsets insets, UIImageResizingMode resizingMode)
    {
            // 理论上可以判断UIColor 是否是 UIDynamicCatalogColor.class, 如果不是, 直接返回原实现; 但没必要.
            UITraitCollection *lightTrait = [self lightTrait];
            UITraitCollection *darkTrait = [self darkTrait];

            UIImage *resizable = ((UIImage * (*)(UIImage *, SEL, UIEdgeInsets, UIImageResizingMode))
                                      originalImp)(_self, selector, insets, resizingMode);
            UIImage *resizableInLight = [_self.imageAsset imageWithTraitCollection:lightTrait];
            UIImage *resizableInDark = [_self.imageAsset imageWithTraitCollection:darkTrait];

            if (resizableInLight)
            {
                [resizable.imageAsset registerImage:((UIImage * (*)(UIImage *, SEL, UIEdgeInsets, UIImageResizingMode))
                                                         originalImp)(resizableInLight, selector, insets, resizingMode)
                                withTraitCollection:lightTrait];
            }
            if (resizableInDark)
            {
                [resizable.imageAsset registerImage:((UIImage * (*)(UIImage *, SEL, UIEdgeInsets, UIImageResizingMode))
                                                         originalImp)(resizableInDark, selector, insets, resizingMode)
                                withTraitCollection:darkTrait];
            }
            return resizable;
    });
    class_replaceMethod(klass, selector, dynamicColorCompatibleImp, method_getTypeEncoding(method));
}

+ (UIImage *)systemDarkModeImageWithLightImage:(UIImage *)lightImage andDarkImage:(UIImage *)darkImage
{
#ifdef __IPHONE_13_0
    if (@available(iOS 13, *))
    {
        UITraitCollection *lightTrait = [self lightTrait];
        UITraitCollection *darkTrait = [self darkTrait];
        
        UIImage * img = [UIImage new];
        [img.imageAsset registerImage:lightImage withTraitCollection:lightTrait];
        [img.imageAsset registerImage:darkImage withTraitCollection:darkTrait];
        
        return [img.imageAsset imageWithTraitCollection:UITraitCollection.currentTraitCollection];
    }
#endif
    return (lightImage ? lightImage : darkImage);
};


@end
