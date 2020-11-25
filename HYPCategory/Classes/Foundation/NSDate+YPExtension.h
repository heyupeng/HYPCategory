//
//  NSDate+YPExtension.h
//  YPDemo
//
//  Created by MAC on 2019/12/4.
//  Copyright © 2019 heyupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (YPExtension)

- (NSDate *)yp_dateByAddingDay:(NSInteger)day;

- (NSDate *)yp_tomorrow;

- (NSDate *)yp_yesterday;

- (NSDate *)yp_dateByAddingMonth:(NSInteger)value;

- (NSDate *)yp_nextMonth;

- (NSDate *)yp_previousMonth;

/**
 * 当前日期所在月份天数
 */
- (NSUInteger)yp_countInMonth;

/**
 * 当前日期所在月份日期集
 */
- (NSArray <NSDate *>*)yp_datesInMonth;

/**
 * 当前日期组成（年、月、日）
 */
- (NSDateComponents *)yp_dateComponents;

@end


@interface NSDate (yp_Creation)

+ (NSDate *)yp_dateFromString:(NSString *)str format:(NSString *)fmt;

+ (NSDate *)yp_dateWithYear:(int)year month:(int)month day:(int)day;

@end


@interface NSDate (yp_Format)
FOUNDATION_EXTERN const NSString * NSDateShortFormatKey;
FOUNDATION_EXTERN const NSString * NSDateLongFormatKey;
FOUNDATION_EXTERN const NSString * NSDateFullFormatKey;
FOUNDATION_EXTERN const NSString * NSDateHourFormatKey;

 /// 日期格式化
- (NSString *)yp_format:(NSString *)fmt;

@end

@interface NSDate (yp_Description)
- (NSString *)yp_description;
@end


@interface NSDate (yp_Festival)

- (NSString *)yp_festival;

@end


@interface NSDate (yp_Chinese_calendar)

- (NSString *)yp_chineseFormat:(NSString *)fmt;

- (NSString *)yp_chinese_description;

- (NSArray *)chineseZodiacSymbols;

- (NSArray *)chineseYearSymbols;

- (NSArray *)chineseMonthSymbols;

- (NSArray *)chineseDaySymbols;

- (NSUInteger)yp_chineseCountInMonth;

- (NSDateComponents *)yp_chineseComponents;

@end

NS_ASSUME_NONNULL_END
