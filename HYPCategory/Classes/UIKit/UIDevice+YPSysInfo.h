//
//  UIDevice+YPSysInfo.h
//  YPDemo
//
//  Created by Peng on 2018/1/23.
//  Copyright © 2018年 heyupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (yp_utsname)

/// 设备硬件号，如"iPhone10,3"。
- (NSString *)yp_machine;

@end

@interface UIDevice (yp_ModelName)

/// 设备型号标识。
- (NSString *)yp_modelIdentifier;

/// 设备型号名称。
- (NSString *)yp_modelName;

@end

@interface UIDevice (yp_Platform)

/// 是否模拟器。
- (BOOL)yp_isSimulator;

/// 是否缺口屏。
- (BOOL)yp_isNotchScreen;

/// 是否iPhone7及以上的机型。
- (BOOL)yp_isIPhone7OrAbove;

@end


@interface UIDevice (yp_ExtensionMethods)

#if __has_include(<AdSupport/AdSupport.h>)
/// 广告标识符 IDFA (advertisingIdentifier)。
- (NSUUID *)yp_IDFA;
#endif


- (BOOL)yp_supportsHaptics;

- (void)yp_feedback;

@end

NS_ASSUME_NONNULL_END
