//
//  UIImage+YPResizableImage.h
//  YPDemo
//
//  Created by Mac on 2020/03/31.
//  Copyright © 2020 heyupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (yp_ResizableImage)
/// 图像区域截取
- (UIImage *)yp_resizableImageInRect:(CGRect)rect;
/// 方形图
- (UIImage *)yp_squareImage;
/// 圆角图
- (UIImage *)yp_circleImage;

@end

@interface UIImage (yp_SplitImage)
- (UIImage *)yp_imageWithSplitImages:(NSArray<UIImage *> *)images origins:(NSArray<NSValue *> *)points;

@end

NS_ASSUME_NONNULL_END
