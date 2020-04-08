//
//  UIImage+Resize.m
//  iIndustrial
//
//  Created by zjx on 2017/9/15.
//
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage *)resizedImageWithLeft:(float)left top:(float)top bottom:(float)bottom right:(float)right
{
    if([self respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
        return [self resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right)];
    }
    else{
        return [self stretchableImageWithLeftCapWidth:left topCapHeight:top];
    }
}

- (UIImage *)resizedImageWithLeftCap:(float)x topCap:(float)y
{
    if([self respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
        return [self resizableImageWithCapInsets:UIEdgeInsetsMake(y, x, y+1, x+1)];
    }
    else{
        return [self stretchableImageWithLeftCapWidth:x topCapHeight:y];
    }
}

- (UIImage *)resizeCenterStretchImage
{
    return [[self class] resizeImage:self resizingMode:UIImageResizingModeStretch];
}

- (UIImage *)resizeTileImage
{
    return [[self class] resizeImage:self resizingMode:UIImageResizingModeTile];
}

- (UIImage *)scaledImageToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)centerResizeImage
{
    CGSize size = self.size;
    return [self resizedImageWithLeftCap:ceilf(size.width*.5) topCap:ceilf(size.height*.5)];
}

+ (UIImage *)resizeImage:(UIImage *)originImage resizingMode:(UIImageResizingMode)resizingMode
{
    UIEdgeInsets edgeInsets;
    if (UIImageResizingModeTile == resizingMode) // 平铺整个区域
    {
        edgeInsets = UIEdgeInsetsZero;
    }
    else     // 拉伸中间一个像素点
    {
        CGSize size = originImage.size;
        CGFloat x = ceilf(size.width * .5); // 防止模糊
        CGFloat y = ceilf(size.height * .5);
        edgeInsets =  UIEdgeInsetsMake(y, x, y + 1, x + 1);
    }
    
    if ([originImage respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)])
    {
        return [originImage resizableImageWithCapInsets:edgeInsets resizingMode:resizingMode];
    }
    
    return originImage;
}

- (UIImage*)scaleToSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (UIImage *)scaleWithPercent:(float)percent
{
    CGSize nSize = self.size;
    nSize.width = nSize.width * percent;
    nSize.height = nSize.height * percent;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(nSize, NO, 0);
    else
        UIGraphicsBeginImageContext(nSize);
    CGRect imageRect = CGRectMake(0.0, 0.0,nSize.width,nSize.height);
    [self drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)scaleToSizeWithMaxWidthORHeight:(CGFloat)maxWidthOrHeight
{
    UIImage *newImage1;
    CGFloat newWidth ;
    CGFloat newHeigh;
    if ((self.size.width>maxWidthOrHeight) || (self.size.height>maxWidthOrHeight)) {
        if (self.size.width>self.size.height) {
            newWidth = maxWidthOrHeight;
            newHeigh =newWidth *self.size.height/self.size.width;
        } else {
            newHeigh = maxWidthOrHeight;
            newWidth =newHeigh *self.size.width/self.size.height;
            
        }
        newImage1 = [self scaledImageToSize:CGSizeMake(newWidth, newHeigh)];
        return newImage1;
    } else {
        return self;
    }
}

+ (UIImage *)fixOrientation:(UIImage *)aImage
{
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
