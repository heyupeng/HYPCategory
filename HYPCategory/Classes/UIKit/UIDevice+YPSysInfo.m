//
//  UIDevice+YPSysInfo.m
//  YPDemo
//
//  Created by Peng on 2018/1/23.
//  Copyright © 2018年 heyupeng. All rights reserved.
//

#import "UIDevice+YPSysInfo.h"
#import <sys/utsname.h>

#import <CoreHaptics/CoreHaptics.h>

#import "UIScreen+YPNotchScreen.h"

@implementation UIDevice (yp_utsname)

- (NSString *)yp_machine {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * machine = [NSString stringWithUTF8String:systemInfo.machine];
    return machine;
}

@end


/// 型号标识与型号名称映射:  https://www.theiphonewiki.com/wiki/Models#iPhone
@implementation UIDevice (yp_ModelName)

/// 设备型号标识。真机从 `utsname` 读取，模拟器从`NSProcessInfo`读取。
- (NSString *)yp_modelIdentifier {
    // 模拟器环境，utsname.machine 为 "i386"||"x86_64"，需要从 processInfo 读取。
    if (TARGET_OS_SIMULATOR) {
        NSProcessInfo * processInfo = [NSProcessInfo processInfo];
        NSDictionary * environment = processInfo.environment;
        if ([[environment allKeys] containsObject:@"SIMULATOR_MODEL_IDENTIFIER"]) {
            return [environment objectForKey:@"SIMULATOR_MODEL_IDENTIFIER"];
        }
    }
    return [self yp_machine];
}

/// 设备型号名称。
- (NSString *)yp_modelName {
    static NSString * identifier;
    if (!identifier) {
        identifier = [self yp_modelIdentifier];
    }
    
    if ([identifier hasPrefix:@"iPhone"]) {
        return [self iPhoneModelName:identifier];
    }
    else if ([identifier isEqualToString:@"iPod"]) {
        return [self iPodModelName:identifier];
    }
    else if ([identifier isEqualToString:@"iPad"]) {
        return [self iPadModelName:identifier];
    }
    else if ([identifier isEqualToString:@"AppleTV"]) {
        return [self AppleTVModelName:identifier];
    }
    
    return identifier;
}

- (NSString *)iPhoneModelName:(NSString *)platform {
    // iPhone machine identifier
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7"; //国行、日版、港行
    if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus"; //港行、国行
    if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7"; //美版、台版
    if ([platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus"; //美版、台版
    if ([platform isEqualToString:@"iPhone10,1"])   return @"iPhone 8"; //国行(A1863)、日行(A1906)
    if ([platform isEqualToString:@"iPhone10,4"])   return @"iPhone 8"; //美版(Global/A1905)
    if ([platform isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus"; //国行(A1864)、日行(A1898)
    if ([platform isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus"; //美版(Global/A1897)
    
    if ([platform isEqualToString:@"iPhone10,3"])   return @"iPhone X"; //国行(A1865)、日行(A1902)
    if ([platform isEqualToString:@"iPhone10,6"])   return @"iPhone X"; //美版(Global/A1901)
    
    if ([platform isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    
    if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
    
    if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
    
    if ([platform isEqualToString:@"iPhone13,1"]) return @"iPhone 12 mini";
    if ([platform isEqualToString:@"iPhone13,2"]) return @"iPhone 12";
    if ([platform isEqualToString:@"iPhone13,3"]) return @"iPhone 12 Pro";
    if ([platform isEqualToString:@"iPhone13,4"]) return @"iPhone 12 Pro Max";
    
    return platform;
}

- (NSString *)iPodModelName:(NSString *)platform {
    // iPod
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    return platform;
}

- (NSString *)iPadModelName:(NSString *)platform {
    // iPad
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    
    if ([platform isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([platform isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    
    if ([platform isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([platform isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([platform isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([platform isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    if ([platform isEqualToString:@"iPad6,11"])     return @"iPad 5 (WiFi)";
    if ([platform isEqualToString:@"iPad6,12"])     return @"iPad 5 (Cellular)";
    
    if ([platform isEqualToString:@"iPad7,1"])      return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    if ([platform isEqualToString:@"iPad7,2"])      return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    if ([platform isEqualToString:@"iPad7,3"])      return @"iPad Pro 10.5 inch (WiFi)";
    if ([platform isEqualToString:@"iPad7,4"])      return @"iPad Pro 10.5 inch (Cellular)";
    
    if ([platform isEqualToString:@"iPad8,1"] ||
        [platform isEqualToString:@"iPad8,2"] ||
        [platform isEqualToString:@"iPad8,3"] ||
        [platform isEqualToString:@"iPad8,4"]) return @"iPad Pro 11-inch";
    if ([platform isEqualToString:@"iPad8,5"] ||
        [platform isEqualToString:@"iPad8,6"] ||
        [platform isEqualToString:@"iPad8,7"] ||
        [platform isEqualToString:@"iPad8,8"]) return @"iPad Pro 12.9-inch 3";
    if ([platform isEqualToString:@"iPad8,9"] ||
        [platform isEqualToString:@"iPad8,10"]) return @"iPad Pro 11-inch 2";
    if ([platform isEqualToString:@"iPad8,11"] ||
        [platform isEqualToString:@"iPad8,12"]) return @"iPad Pro 12.9-inch 4";
    
    if ([platform isEqualToString:@"iPad11,1"] ||
        [platform isEqualToString:@"iPad11,2"]) return @"iPad mini 5";
    if ([platform isEqualToString:@"iPad11,3"] ||
        [platform isEqualToString:@"iPad11,4"]) return @"iPad Air 3";
    if ([platform isEqualToString:@"iPad11,6"] ||
        [platform isEqualToString:@"iPad11,7"]) return @"iPad 8";
    
    if ([platform isEqualToString:@"iPad13,1"] ||
        [platform isEqualToString:@"iPad12,2"]) return @"iPad Air 4";
    
    return platform;
}

- (NSString *)AppleTVModelName:(NSString *)platform {
    // AppleTV
    if ([platform isEqualToString:@"AppleTV2,1"])    return @"Apple TV 2";
    
    if ([platform isEqualToString:@"AppleTV3,1"])    return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV3,2"])    return @"Apple TV 3";
    
    if ([platform isEqualToString:@"AppleTV5,3"])    return @"Apple TV 4";
    
    return platform;
}

@end

@implementation UIDevice (yp_Platform)

/// 是否模拟器。
- (BOOL)yp_isSimulator {
    if (TARGET_OS_SIMULATOR) {
        return YES;
    }
    return NO;
}

/// 是否缺口屏。
- (BOOL)yp_isNotchScreen {
    return [UIScreen.mainScreen yp_isNotchScreen];
}

/// 是否iPhone7及以上的机型。
- (BOOL)yp_isIPhone7OrAbove {
    /// >=  "iPhone9,1"
    NSString * modelID = [self yp_modelIdentifier];
    if (![modelID hasPrefix:@"iPhone"]) return NO;
    modelID = [modelID substringFromIndex:6];
    if ([modelID intValue] < 9) {
        return NO;
    }
    return YES;
}

@end

#if __has_include(<AdSupport/AdSupport.h>)
#import <AdSupport/AdSupport.h>
#endif
#if __has_include(<AppTrackingTransparency/AppTrackingTransparency.h>)
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#endif

#import <AudioToolbox/AudioToolbox.h>

@implementation UIDevice (yp_ExtensionMethods)

#if __has_include(<AdSupport/AdSupport.h>)
/// 广告标识符 advertisingIdentifier。iOS 14以上需配置info.plist授权描述，app store connect隐私信息。
- (NSUUID *)yp_IDFA {
    __block NSUUID * idfa = nil;
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            dispatch_semaphore_signal(sem);
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                idfa = [[ASIdentifierManager sharedManager] advertisingIdentifier];
            }
            else if (status == ATTrackingManagerAuthorizationStatusDenied) {
                NSLog(@"已拒绝IDFA授权");
            }
        }];
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    } else {
        // 使用原方式访问 IDFA
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            idfa = [[ASIdentifierManager sharedManager] advertisingIdentifier];
        }
    }
    NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSSystemDomainMask, NO);
    NSLog(@"IDFA: %@", idfa);
    return idfa;
}
#endif

/// 普通短震 (3D Touch 中 Peek 震动反馈) 1519 ;
/// 普通短震 (3D Touch 中 Pop 震动反馈) 1520 ;
/// 连续三次短震 1521 ;

int yp_kSystemSoundID_SMSReceived = 1003;
int yp_kSystemSoundID_TouchPeek = 1519;
int yp_kSystemSoundID_TouchPop = 1520;
int yp_kSystemSoundID_3_ShortVibrate = 1520;

/// 触觉硬件支持。
- (BOOL)yp_supportsHaptics {
    bool supportsHaptics = NO; // 触觉硬件支持
    if (@available(iOS 13.0, *)) {
        id <CHHapticDeviceCapability> hapticEngine = [CHHapticEngine capabilitiesForHardware];
        supportsHaptics = [hapticEngine supportsHaptics];
    }
    else if (@available(iOS 10.0, *)) {
        if ([self yp_isIPhone7OrAbove]) {
            supportsHaptics = YES;
        }
    }
    return supportsHaptics;
}

/// 触觉反馈。
- (void)yp_feedback {
    if (@available(iOS 10.0, *)) {
        bool supportsHaptics = [self yp_supportsHaptics];
        if (supportsHaptics) {
            // 反馈发生器响应发生的要求:1.硬件支持（iPhone7及以上）；2.iOS 10及以上, 开启触觉支持；
            static UIImpactFeedbackGenerator * feedbackGenerator;
            if (!feedbackGenerator) {
                feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
                [feedbackGenerator prepare];
            }
            [feedbackGenerator impactOccurred];
            return;
        }
    }
    
    int sound = yp_kSystemSoundID_SMSReceived;
    AudioServicesPlaySystemSound(sound);
}
@end
