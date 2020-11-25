//
//  UIImage+YPResizableImage.m
//  YPDemo
//
//  Created by Mac on 2020/11/4.
//  Copyright © 2020 heyupeng. All rights reserved.
//

#import "UIImage+YPResizableImage.h"

@implementation UIImage (yp_ResizableImage)

- (UIImage *)yp_resizableImageInRect:(CGRect)rect {
    if (self.size.width <= 0 || self.size.height <= 0) {
        return nil;
    }
    UIImage * newImage;
#if 1
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);
    [self drawInRect:rect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
#else
    CGImageRef newImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    newImage = [UIImage imageWithCGImage:newImageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(newImageRef);
#endif
    
    return newImage;
}

- (CGRect)yp_squareRect {
    CGRect rect = CGRectZero;
    rect.size = self.size;
    if (self.size.width <= 0 || self.size.height <= 0) {
        return rect;
    }
    if (self.size.width == self.size.height) {
        return rect;
    }
    
    CGSize size = self.size;
    if (size.width > size.height) {
        rect.origin.x = (size.width - size.height) * 0.5;
        rect.size.width = size.height;
    } else {
        rect.origin.y = (size.height - size.width) * 0.5;
        size.height = rect.size.width;
    }
    return rect;
}

- (UIImage *)yp_squareImage {
    if (self.size.width <= 0 || self.size.height <= 0) {
        return nil;
    }
    if (self.size.width == self.size.height) {
        return self;
    }
    CGRect rect = [self yp_squareRect];
    
    return [self yp_resizableImageInRect:rect];
}

- (UIImage *)yp_circleImage {
    if (self.size.width <= 0 || self.size.height <= 0) {
        return nil;
    }
    
    UIImage * newImage = self;
    CGRect rect = [self yp_squareRect];
    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    UIGraphicsBeginImageContext(rect.size);
    [path addClip];
    [newImage drawInRect:rect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end

@implementation UIImage (yp_SplitImage)
- (UIImage *)yp_imageWithSplitImages:(NSArray<UIImage *> *)images origins:(NSArray<NSValue *> *)points {
    if (!images || images.count == 0) {
        return self;
    }
    UIImage * outputImage;
    
    UIGraphicsBeginImageContextWithOptions(self.size, YES, self.scale);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height) blendMode:kCGBlendModeColor alpha:1];
    
    for (int i = 0; i < images.count; i ++) {
        UIImage * image = [images objectAtIndex:i];
        CGPoint point = CGPointZero;
        if (i < points.count) {
            point = [[points objectAtIndex:i] CGPointValue];
        }
        [image drawInRect:CGRectMake(point.x, point.y, image.size.width, image.size.height)];
    }
    
    outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

@end
