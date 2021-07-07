//
//  UIImage+Extension.h
//  YPDemo
//
//  Created by Mac on 2020/03/31.
//  Copyright © 2020 heyupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN UIImage * H_UIGraphicsImageDrawerWithOptions(CGSize size, BOOL opaque, CGFloat scale, void(^drawingAction)(CGContextRef ctx));

UIKIT_EXTERN UIImage * H_UIGraphicsImageRenderer(CGSize size, void(^drawingAction)(CGContextRef ctx));
UIKIT_EXTERN UIImage * H_UIGraphicsImageRendererWithOptions(CGSize size, BOOL opaque, CGFloat scale, void(^drawingAction)(CGContextRef ctx));

@interface UIImage (yp_ResizableImage)
/// 图像区域截取
- (UIImage *)yp_resizableImageInRect:(CGRect)rect;
/// 方形图
- (UIImage *)yp_squareImage;
/// 圆角图
- (UIImage *)yp_circleImage;

@end

/* 合并图像 */
@interface UIImage (yp_MergeImage)

- (UIImage *)yp_mergeImage:(UIImage *)image contentMode:(UIViewContentMode)contentMode;

- (UIImage *)yp_mergeImage:(UIImage *)image origin:(CGPoint)point;
- (UIImage *)yp_mergeImages:(NSArray<UIImage *> *)images origins:(NSArray<NSValue *> *)points;

@end

/* UIImage 与 base64 的转化 */
@interface UIImage (yp_Base64)

- (NSString *)yp_base64StringForPNG;
- (NSString *)yp_base64StringForJPEG;

- (instancetype)initWithBase64String:(NSString *)base64String;
- (instancetype)initWithBase64Data:(NSData *)base64Data;

@end

NS_ASSUME_NONNULL_END
