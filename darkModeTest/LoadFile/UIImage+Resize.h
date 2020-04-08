//
//  UIImage+Resize.h
//  iIndustrial
//
//  Created by zjx on 2017/9/15.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

/**
 指定边距拉伸图片

 @param left 左端盖宽度
 @param top 顶端盖高度
 @param bottom 底端盖高度
 @param right 右端盖高度
 @return 返回拉伸后的图片
 */
- (UIImage *)resizedImageWithLeft:(float)left top:(float)top bottom:(float)bottom right:(float)right;

/**
 *  指定边距拉伸图片
 *
 *  @param x x轴边距位置
 *  @param y y轴边距位置
 *
 *  @return 返回拉伸后图片
 */
- (UIImage *)resizedImageWithLeftCap:(float)x topCap:(float)y;

/**
 *  拉伸最中间一个像素点来填充图片
 *
 *  @return 拉伸过后的image
 */
- (UIImage *)resizeCenterStretchImage;

/**
 *  重复显示整个图片来填充图片（平铺）
 *
 *  @return 平铺过后的image
 */
- (UIImage *)resizeTileImage;

/**
 *  缩放图片尺寸到指定Size
 *
 *  @param newSize
 *
 *  @return 返回缩放后图片
 */
- (UIImage *)scaledImageToSize:(CGSize)newSize;

/**
 *  居中拉伸图片
 */
- (UIImage *)centerResizeImage;

/**
 *  等比例缩放
 */
- (UIImage *)scaleToSize:(CGSize)size;

/**
 *  按比例缩放
 */
- (UIImage *)scaleWithPercent:(float)percent;

/**
 *  限制宽高缩放
 */
- (UIImage*)scaleToSizeWithMaxWidthORHeight:(CGFloat)maxWidthOrHeight;

/**
 *  处理图片方向
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

@end
