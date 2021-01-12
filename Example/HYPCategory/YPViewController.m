//
//  YPViewController.m
//  HYPCategory
//
//  Created by heyupeng on 11/24/2020.
//  Copyright (c) 2020 heyupeng. All rights reserved.
//

#import "YPViewController.h"
#import <HYPCategory-umbrella.h>

#import <YPCategory.h>
@interface YPViewController ()

@end

@implementation YPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self digestTests];
    
    [self hexStringTests];
    
    [self safeAreaTests];
    
    [self cryptTests];
    
    [self arrayTests];
    
}

- (void)digestTests {
    NSString * str = @"我的世界";
    
    NSLog(@"md5: \n %@", [str yp_md5]);
    NSLog(@"sha224: \n %@", [str yp_sha224]);
    NSLog(@"sha256: \n %@", [str yp_sha256]);
    NSLog(@"sha384: \n %@", [str yp_sha384]);
    NSLog(@"sha512: \n %@", [str yp_sha512]);
}

- (void)safeAreaTests {
    UIEdgeInsets sets0 = UIApplication.sharedApplication.yp_safeAreaInsets;
    UIEdgeInsets sets1 = UIApplication.sharedApplication.yp_safeAreaInsets1;
    
    NSLog(@"window safeArea: %@", NSStringFromUIEdgeInsets(sets0));
    NSLog(@"custom safeArea: %@", NSStringFromUIEdgeInsets(sets1));
}

- (void)hexStringTests {
    NSString * hex = @"0x678593205512";
    NSData * data = [NSData yp_dataWithHexString:hex];
    
    NSInteger intger = [data yp_hexIntegerValue];
    long long longlong = [data yp_hexLongLongValue];
    int i = [data yp_hexIntValue];
    NSString * hex1 = [data yp_hexString];
    
    NSLog(@"\n hex: %@ \n data: %@ \
          \n longValue: %lld \n intValue %d",
          hex, data.debugDescription,
          longlong, i);
}

- (void)cryptTests {
    NSString * str = @"我的世界";
    NSString * key = @"123";
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData * encryptedData = [data yp_AES128EncryptedDataWithKey:key];
    NSString * encrypted_base64String = [encryptedData base64EncodedStringWithOptions:0];
    NSLog(@"\n Data: %@ \n encryptedData: %@ \n Base64String: %@",
          data.hexString, encryptedData.yp_hexString, encrypted_base64String);
    
    NSData * decryptedData = [encryptedData yp_AES128DecryptedDataWithKey:key];
    NSString * decrypted_string = [[NSString alloc] initWithData:decryptedData  encoding:NSUTF8StringEncoding];
    NSLog(@"\n Data: %@ \n decryptedData: %@ \n decryptedString: %@",
          encryptedData.hexString, decryptedData.yp_hexString, decrypted_string);
}

- (void)arrayTests {
    NSArray * array = @[@1,@2,@3,@4];
    
    NSNumber * obj1 = [array yp_objectAtIndexInLoop:-5];
    
    NSNumber * obj2 = [array yp_objectAtIndexSafely:5];
    
    NSLog(@"\n `yp_objectAtIndexInLoop:` index:-5, value: %@; \
            \n `yp_objectAtIndexSafely:` index:5, value: %@",
          obj1, obj2);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    UIEdgeInsets insets = self.view.safeAreaInsets;
    NSLog(@"viewSafeAreaInsets: %@", NSStringFromUIEdgeInsets(insets));
}
@end
