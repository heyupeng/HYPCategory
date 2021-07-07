//
//  UIImage+Extension.m
//  YPDemo
//
//  Created by Mac on 2020/11/4.
//  Copyright © 2020 heyupeng. All rights reserved.
//

#import "UIImage+Extension.h"

#pragma mark - Implementation C Func

/// 创建一张 RGBA 32-bit 的渲染图像，绘制内容交由 drawingAction。
/// @param size 图像大小。( The size (measured in points) of the new bitmap context. )
/// @param opaque 不透明布尔值。( A Boolean flag indicating whether the bitmap is opaque. )
/// @param scale 图像倍数。为0时，取值当前设备屏幕比例因子。( The scale factor to apply to the bitmap. )
/// @param drawingAction  渲染绘图块。( A DrawingAction block that, when invoked by the renderer, executes a set of drawing instructions to create the output image. )
UIImage * H_UIGraphicsImageDrawerWithOptions(CGSize size, BOOL opaque, CGFloat scale, void(^drawingAction)(CGContextRef ctx)) {
    // 1. 开启画笔
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
    // 2. 绘制工作交由外部
    drawingAction(UIGraphicsGetCurrentContext());
    // 3. 提取图像
    UIImage * output = UIGraphicsGetImageFromCurrentImageContext();
    // 4. 结束绘制
    UIGraphicsEndImageContext();
    return output;
}

/// 创建一张绘制的渲染图像。iOS 10.0 及以上，使用 UIGraphicsImageRenderer 类，格式自适应。iOS 10 以下，相当于调用 H_UIGraphicsImageDrawerWithOptions。
/// @param size 图像大小。( The size (measured in points) of the new bitmap context. )
/// @param opaque 不透明布尔值。( A Boolean flag indicating whether the bitmap is opaque. )
/// @param scale 图像倍数。为0时，取值当前设备屏幕比例因子。( The scale factor to apply to the bitmap. )
/// @param drawingAction  渲染绘图块。( A DrawingAction block that, when invoked by the renderer, executes a set of drawing instructions to create the output image. )
UIImage * H_UIGraphicsImageRendererWithOptions(CGSize size, BOOL opaque, CGFloat scale, void(^drawingAction)(CGContextRef ctx)) {
    UIImage * output;
    if (@available(iOS 10.0, *)) {
        /// UIGraphicsImageRenderer 一个图形渲染器,用于创建核心图形支持的图像。
        /// iOS 10.0 新增。iOS 12.0 自动选择最佳图形格式，可降低内存，提升性能，相比 UIGraphicsBeginImageContextWithOptions 最高降低内存75%。
        UIGraphicsImageRendererFormat * format = [[UIGraphicsImageRendererFormat alloc] init];
        format.opaque = opaque;
        format.scale = scale;
        UIGraphicsImageRenderer * render = [[UIGraphicsImageRenderer alloc] initWithSize:size format:format];
        output = [render imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
            drawingAction(rendererContext.CGContext);
        }];
    } else {
        output = H_UIGraphicsImageDrawerWithOptions(size, opaque, scale, drawingAction);
    }
    return output;
}

/// 创建一张绘制的渲染图像。相当与调用 H_UIGraphicsImageRendererWithOptions 函数，opaque 为 NO，scale 为 1.0。
UIImage * H_UIGraphicsImageRenderer(CGSize size, void(^drawingAction)(CGContextRef ctx)) {
    return H_UIGraphicsImageRendererWithOptions(size, NO, 1.0, drawingAction);
}

@implementation UIImage (yp_ResizableImage)

/// 图形渲染，用于创建核心图形支持的图像。新图像size，scale 对标原图像。
- (UIImage *)imageRender:(void(^)(CGContextRef ctx))drawingAction {
    CGSize size = self.size;
    CGFloat scale = self.scale;
    BOOL opaque = NO;
    return H_UIGraphicsImageRendererWithOptions(size, opaque, scale, drawingAction);
}

- (UIImage *)yp_resizableImageInRect:(CGRect)rect {
    if (self.size.width <= 0 || self.size.height <= 0) {
        return nil;
    }
    UIImage * newImage;
#if 1
    newImage = H_UIGraphicsImageRendererWithOptions(rect.size, NO, self.scale, ^(CGContextRef ctx) {
        [self drawInRect:rect];
    });
#else
    CGImageRef newImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    newImage = [UIImage imageWithCGImage:newImageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(newImageRef);
#endif
    
    return newImage;
}

/// 图像最大方形区域。
- (CGRect)yp_squareRect {
    CGSize size = self.size;
    if (size.width <= 0 || size.height <= 0) {
        return CGRectZero;
    }
    CGRect rect = CGRectZero;
    rect.size = size;
    if (self.size.width == self.size.height) {
        return rect;
    }
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
    newImage = H_UIGraphicsImageRendererWithOptions(rect.size, NO, newImage.scale, ^(CGContextRef ctx) {
        [path addClip];
        [newImage drawInRect:rect];

    });
    return newImage;
}

@end

@implementation UIImage (yp_MergeImage)

/// 合并图像。
/// @param image 合并图像。
/// @param point 定位合并图像绘制原点。
- (UIImage *)yp_mergeImage:(UIImage *)image origin:(CGPoint)point {
    if (image == nil) return self;
    
    UIImage * output = [self imageRender:^(CGContextRef ctx) {
        // 1.
        [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height) blendMode:kCGBlendModeColor alpha:1];
        // 2.
        [image drawInRect:CGRectMake(point.x, point.y, image.size.width, image.size.height)];
    }];
    return output;
}


/// 合并图像。
/// @param image 合并图像。
/// @param contentMode 合并方式。
- (UIImage *)yp_mergeImage:(UIImage *)image contentMode:(UIViewContentMode)contentMode {
    if (image == nil) return self;
    
    UIImage * output = [self imageRender:^(CGContextRef ctx) {
        CGSize size = self.size;
        CGSize imageSize = image.size;
        
        CGPoint origin = CGPointZero;
        switch (contentMode) {
            case UIViewContentModeCenter:
                origin.x = (size.width - imageSize.width) * 0.5;
                origin.y = (size.height - imageSize.height) * 0.5;
                break;
            case UIViewContentModeTopLeft:
                
                break;
            case UIViewContentModeTopRight:
                origin.x = (size.width - imageSize.width);
                break;
            case UIViewContentModeBottomLeft:
                origin.x = (size.width - imageSize.width);
                break;
            case UIViewContentModeBottomRight:
                origin.x = (size.width - imageSize.width);
                origin.y = (size.height - imageSize.height);
                break;
                
            default:
                break;
        }
        
        // 1.
        [self drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeColor alpha:1];
        // 2.
        [image drawInRect:CGRectMake(origin.x, origin.y, imageSize.width, imageSize.height)];
    }];
    return output;
}

/// 合并图像。
/// @param images 需要合并的图像集。
/// @param points 定位绘制原点的点集。可为 nil 。
- (UIImage *)yp_mergeImages:(NSArray<UIImage *> *)images origins:(NSArray<NSValue *> *)points {
    if (images.count < 1) return self;
    UIImage * output;
    output = [self imageRender:^(CGContextRef ctx) {
        // 1.
        [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height) blendMode:kCGBlendModeColor alpha:1];
        // 2.
        for (int i = 0; i < images.count; i ++) {
            UIImage * image = [images objectAtIndex:i];
            CGPoint point = CGPointZero;
            if (points && i < points.count) {
                point = [[points objectAtIndex:i] CGPointValue];
            }
            [image drawInRect:CGRectMake(point.x, point.y, image.size.width, image.size.height)];
        }
    }];
    
    return output;
}

@end

@implementation UIImage (yp_Base64)

- (NSString *)yp_base64StringForPNG {
    NSData * imageData = UIImagePNGRepresentation(self);
    NSString * base64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64;
}

- (NSString *)yp_base64StringForJPEG {
    NSData * imageData = UIImageJPEGRepresentation(self, 1.0);
    NSString * base64 = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64;
}

- (instancetype)initWithBase64String:(NSString *)base64String {
    NSData * imageData = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [self initWithData:imageData];
}

- (instancetype)initWithBase64Data:(NSData *)base64Data {
    NSData * imageData = [[NSData alloc] initWithBase64EncodedData:base64Data options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [self initWithData:imageData];
}

@end
