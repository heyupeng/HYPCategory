//
//  UIImage+YPBitmap.h
//  YPDemo
//
//  Created by MAC on 2020/3/31.
//  Copyright © 2020 heyupeng. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (yp_Bitmap)

- (UIImage *)imageUsingBitmap:(void(^)(UInt8 * data, size_t width, size_t height))block;

- (UIImage *)yp_adjustableImageUsingBitmap:(void(^)(UInt8 * data, CGImageRef imageRef, size_t width, size_t height, size_t bytesPerRow))block;

- (void)yp_mainColors;
@end

NS_ASSUME_NONNULL_END
