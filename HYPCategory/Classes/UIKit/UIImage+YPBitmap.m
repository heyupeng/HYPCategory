//
//  UIImage+YPBitmap.m
//  YPDemo
//
//  Created by MAC on 2020/3/31.
//  Copyright © 2020 heyupeng. All rights reserved.
//

#import "UIImage+YPBitmap.h"


@implementation UIImage (yp_Bitmap)

// RowData need to be freed
- (unsigned char *)rowData {
    if (self.size.width == 0 || self.size.height == 0) {return nil;}
        
    UIImage * image = self;
    CGImageRef imageRef = image.CGImage;
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef); // 每行像素的总字节数
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef); // 8; // r g b a 每个component bits数目
//    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef); // 每个像素多少位(RGBA 4个字节，每个8位，所以这里是32位)

    unsigned char *data = calloc(bytesPerRow * height, sizeof(unsigned char)); // 取图片首地址(一行字节大小 bytesPerRow 不一定等于 imageWith * 4，所以这里开辟空间不采用 width * 4，而是采用 bytesPerRow)

    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB(); // 创建rgb颜色空间
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef); // kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big
    
    CGContextRef context = CGBitmapContextCreate(data, width, height, bitsPerComponent, bytesPerRow, space, bitmapInfo);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
    
    CGColorSpaceRelease(space);
    
    CGContextRelease(context);
    
    return data;
}

- (UIImage *)imageUsingBitmap:(void(^)(UInt8 * data, size_t width, size_t height))block {
    if (!block) {
        return self;
    }
    if (self.size.width == 0 || self.size.height == 0) {return self;}
    
    UIImage * image = self;
    CGImageRef imageRef = image.CGImage;
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef); // 每行像素的总字节数
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef); // 8; // r g b a 每个component bits数目
//    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef); // 每个像素多少位(RGBA 4个字节，每个8位，所以这里是32位)

    unsigned char *data = calloc(bytesPerRow * height, sizeof(unsigned char)); // 取图片首地址(一行字节大小 bytesPerRow 不一定等于 imageWith * 4，所以这里开辟空间不采用 width * 4，而是采用 bytesPerRow)

    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB(); // 创建rgb颜色空间
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGContextRef context = CGBitmapContextCreate(data, width, height, bitsPerComponent, bytesPerRow, space, bitmapInfo);

    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
        
//    for (size_t i = 0; i < height; i++) {
//        for (size_t j = 0; j < bytesPerRow; j+=4) {
//            size_t pixelIndex = i * bytesPerRow + j;
//            unsigned char red, green, blue;
//        }
//    }
    block(data, bytesPerRow/4, height);
    
    CGImageRef cgimage = CGBitmapContextCreateImage(context);
    UIImage * newImage = [UIImage imageWithCGImage:cgimage];
    
    CGColorSpaceRelease(space);
    free((void *)data);
    CGContextRelease(context);
    CGImageRelease(cgimage);
    
    return newImage;
}

- (UIImage *)yp_adjustableImageUsingBitmap:(void (^)(UInt8 * _Nonnull, CGImageRef, size_t, size_t, size_t))block {
    if (!block) {
        return self;
    }
    if (self.size.width == 0 || self.size.height == 0) {return self;}
    
    UIImage * image = self;
    CGImageRef imageRef = image.CGImage;
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef); // 每行像素的总字节数
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef); // 8; // r g b a 每个component bits数目
//    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef); // 每个像素多少位(RGBA 4个字节，每个8位，所以这里是32位)

    unsigned char *data = calloc(bytesPerRow * height, sizeof(unsigned char)); // 取图片首地址(一行字节大小 bytesPerRow 不一定等于 imageWith * 4，所以这里开辟空间不采用 width * 4，而是采用 bytesPerRow)

    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB(); // 创建rgb颜色空间
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGContextRef context = CGBitmapContextCreate(data, width, height, bitsPerComponent, bytesPerRow, space, bitmapInfo);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
    
//    for (size_t i = 0; i < height; i++) {
//        for (size_t j = 0; j < bytesPerRow; j+=4) {
//            size_t pixelIndex = i * bytesPerRow + bytesPerRow;
//            unsigned char red, green, blue;
//            red = data[pixelIndex];
//            green = data[pixelIndex + 1];
//            blue = data[pixelIndex + 2];
//
//            // 修改颜色
////            data[pixelIndex] = red;
////            data[pixelIndex+1] = green;
////            data[pixelIndex+2] = blue;
//        }
//    }
    
    block(data, imageRef, width, height, bytesPerRow);
    
    CGImageRef cgimage = CGBitmapContextCreateImage(context);
    UIImage * newImage = [UIImage imageWithCGImage:cgimage];
    
    CGColorSpaceRelease(space);
    free((void *)data);
    CGContextRelease(context);
    CGImageRelease(cgimage);
    
    return newImage;
}

- (void)yp_mainColors {
    UIImage * image = self;
    CGImageRef imageRef = self.CGImage;
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef); // 每行像素的总字节数
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef); // 每个像素多少位(RGBA每个8位，所以这里是32位)
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(imageRef);

    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    CGDataProviderRelease(dataProvider);
    
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);// 图片数据的首地址
    size_t count = 0;
    for (int j = 0; j < height; j+=image.scale) {
        for (int i = 0; i < width; i+=image.scale) {
            count ++;
            //每个像素的首地址
            UInt8 *pt = buffer + j * bytesPerRow + i * (bitsPerPixel/8);
            UInt8  red, green, blue, alpha;
            red = *(pt+2);
            green = *(pt+1);
            blue = *(pt+0);
            alpha = *(pt+3);
        }
    }
    NSLog(@"count: %zi",count);

    NSMutableDictionary * colors = [[NSMutableDictionary alloc] initWithCapacity:50];
    NSMutableArray * m_colors = [[NSMutableArray alloc] initWithCapacity:200];
    NSMutableArray * m_colorCounts = [[NSMutableArray alloc] initWithCapacity:200];
    
    UInt32 * pixelBuffer = (UInt32 *)CFDataGetBytePtr(data);
    UInt32 * pixel;
    for (int y = 0; y < height; y+=image.scale) {
       for (int x = 0; x < width; x+=image.scale) {
           pixel = pixelBuffer + x + width * y;
           UInt8 r, g, b, a;
           // UIGraphicsGetImageFromCurrentImageContext() 所获取的图片为 kCGImageAlphaPremultipliedFirst
           if (alpha == kCGImageAlphaPremultipliedFirst || alpha == kCGImageAlphaFirst || alpha == kCGImageAlphaNoneSkipFirst) {
               // ARGB / BGRA
               a = *pixel >> (8*3) & 0xff;
               r = *pixel >> (8*2) & 0xff;
               g = *pixel >> (8*1) & 0xff;
               b = *pixel >> (8*0) & 0xff;
           } else {
               // RGBA
               r = *pixel >> 0 & 0xff;
               g = *pixel >> 8 & 0xff;
               b = *pixel >> 16 & 0xff;
               a = *pixel >> 24 & 0xff;
           }

           UInt32 colorValue = r << 24 | g << 16 | b << 8 | a;
           if ([m_colors containsObject:[NSNumber numberWithLong:colorValue]]) {
               NSInteger index = [m_colors indexOfObject:[NSNumber numberWithLong:colorValue]];
               NSInteger value = [[m_colorCounts objectAtIndex:index] longValue];
               [m_colorCounts replaceObjectAtIndex:index withObject:[NSNumber numberWithLong:value+1]];
           } else {
               [m_colors addObject:[NSNumber numberWithLong:colorValue]];
               [m_colorCounts addObject:[NSNumber numberWithLong:1]];
           }

//           NSString * color = [NSString stringWithFormat:@"%.2x%.2x%.2x%.2x", r, g, b, a];
//           NSNumber * color = [NSNumber numberWithUnsignedInt:colorValue];
//           if (![[colors allKeys] containsObject:color]) {
//               [colors setObject:[NSNumber numberWithLong:1] forKey:color];
//           } else {
//               NSInteger value = [[colors objectForKey:color] longValue];
//               [colors setObject:[NSNumber numberWithLong: ++value] forKey:color];
//           }
       }
    }
    return;
    // 删除计数不大于1的色值
    int minimum = 2; minimum = bytesPerRow / 4 / image.scale * 0.1;
    [colors.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[colors objectForKey:obj] intValue] < minimum) {
            [colors removeObjectForKey:obj];
        }
    }];
    
//    NSArray * array = [self top10Colors:colors];
    NSLog(@"main colors :\n%@", colors);
}

- (NSArray *)top10Colors:(NSDictionary *)colorsDict {
    NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:10];
    __block int i = 1;
    [colorsDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj intValue] > [[array.lastObject objectForKey:@"count"] intValue]) {
            [array insertObject:@{@"color": key, @"count": obj} atIndex:0];
        }
        
        i++;
        if (array.count % 10 == 0 || i == colorsDict.count) {
            // 每增加10位进行一次排序，取前十位
            [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [[obj1 objectForKey:@"count"] intValue] < [[obj2 objectForKey:@"count"] intValue];
            }];
            
            // array = [NSMutableArray arrayWithArray:[array subarrayWithRange:NSMakeRange(0, 10)]];
            for (int j = 10; j < array.count; j++) {
                [array removeLastObject];
                j--;
            }
        }
    }];
    return array;
}
@end
