//
//  DarkModeLoadFile.h
//  darkModeTest
//
//  Created by 魏文彬 on 2020/4/2.
//  Copyright © 2020 XW. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DarkModeLoadFile : NSObject

+ (UIImage *)systemDarkModeImageWithLightImage:(UIImage *)lightImage andDarkImage:(UIImage *)darkImage;

@end

NS_ASSUME_NONNULL_END
