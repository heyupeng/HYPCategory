//
//  NSDate+YPExtension.m
//  YPDemo
//
//  Created by MAC on 2019/12/4.
//  Copyright © 2019 heyupeng. All rights reserved.
//

#import "NSDate+YPExtension.h"

@implementation NSDate (YPExtension)

@end

@implementation NSDate (yp_Creation)

/// 以给定的格式化字符串返回 NSDate
/// @param str 日期字符串
/// @param fmt 日期格式
+ (NSDate *)yp_dateFromString:(NSString *)str format:(NSString *)fmt {
    NSDateFormatter * dateFormatter;
    dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = fmt;
    return [dateFormatter dateFromString:str];
}

+ (NSDate *)yp_dateWithYear:(int)year month:(int)month day:(int)day {
    NSDateComponents * cmp = [[NSDateComponents alloc] init];
    cmp.year = year;
    cmp.month = month;
    cmp.day = day;
    
    NSCalendar * calendar = [NSCalendar currentCalendar];
    return [calendar dateFromComponents:cmp];
}

@end


@implementation NSDate (yp_DateFormat)
/// @"yyyy-MM-dd HH:mm:ss";
const NSDateFromatKey NSDateFormatDateAndTimeKey = @"yyyy-MM-dd HH:mm:ss";
///
const NSDateFromatKey NSDateFormatDateKey = @"yyy-MM-dd";
///
const NSDateFromatKey NSDateFormatTimeKey = @"HH:mm:ss";

/// 日期格式化（本地时区）
/// @param format 格式 ("yyyy-MM-dd", "HH:mm:ss.S", "Z" )
- (NSString *)yp_format:(NSString *)format {
    if (!format) {return nil;}
    
    static NSDateFormatter * dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
    }
    dateFormatter.dateFormat = format;

    return [dateFormatter stringFromDate:self];
}

@end


@implementation NSDate (YPDescription)

- (NSString *)yp_description {
    return [self yp_format:@"yyyy-MM-dd HH:mm:ss.SSS Z"];
}

- (NSString *)yp_short_description {
    return [self yp_format:@"HH:mm:ss.SSS"];
}

@end


@implementation NSDate (yp_DateComponents)
/// 当前日期组成（年、月、日、星期、当月周序列）
- (NSDateComponents *)yp_dateComponents {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSCalendarUnit flags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekdayOrdinal;
    return [calendar components:flags fromDate:self];
}

- (NSDateComponents *)yp_dateComponentsWithUnit:(NSCalendarUnit)unitFlags  {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    return [calendar components:unitFlags fromDate:self];
}

/// 年序列号。
- (NSUInteger)yp_year {
    NSDateComponents * cmps = [self yp_dateComponentsWithUnit:NSCalendarUnitYear];
    return cmps.year;
}

/// 月序列号。[1, 12]。
- (NSUInteger)yp_month {
    NSDateComponents * cmps = [self yp_dateComponentsWithUnit:NSCalendarUnitMonth];
    return cmps.month;
}

/// 日序列号。[1, 31]。
- (NSUInteger)yp_day {
    NSDateComponents * cmps = [self yp_dateComponentsWithUnit:NSCalendarUnitDay];
    return cmps.day;
}

/// 周天序列号。以周日为始，周六为末，[1, 7]
- (NSInteger)yp_weekday {
    NSDateComponents * cmps = [self yp_dateComponentsWithUnit:NSCalendarUnitWeekday];
    return cmps.weekday;
}

@end


@implementation NSDate (yp_DateProcessing)
/// 午夜零点整。当天 00:00；
- (NSDate *)yp_midnight {
    NSInteger flag = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents * cmps = [[NSCalendar currentCalendar] components:flag fromDate:self];
    NSDate * date = [[NSCalendar currentCalendar] dateFromComponents:cmps];
    return date;
}

/// 一天之始。基于当前日历，午夜零点整，当天 00:00；
- (NSDate *)yp_startDateInDay {
    NSInteger flag = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents * cmps = [[NSCalendar currentCalendar] components:flag fromDate:self];
    NSDate * date = [[NSCalendar currentCalendar] dateFromComponents:cmps];
    return date;
}

/// 一天之终。基于当前日历，午夜零点整前，当天 23:59:59；
- (NSDate *)yp_endDateInday {
    NSInteger flag = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents * cmps = [[NSCalendar currentCalendar] components:flag fromDate:self];
    cmps.hour = 23;
    cmps.minute = 59;
    cmps.second = 59;
    NSDate * date = [[NSCalendar currentCalendar] dateFromComponents:cmps];
    return date;
}

/// 一月之始。基于当前日历，午夜零点整，00:00:00；
- (NSDate *)yp_firstDateInMomth {
    NSInteger flag = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents * cmps = [[NSCalendar currentCalendar] components:flag fromDate:self];
    cmps.day = 1;
    NSDate * date = [[NSCalendar currentCalendar] dateFromComponents:cmps];
    return date;
}

/// 一月之终。基于当前日历，午夜零点整，00:00:00；
- (NSDate *)yp_lastDateInMomth {
    NSInteger flag = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents * cmps = [[NSCalendar currentCalendar] components:flag fromDate:self];
    cmps.day = 1;
    cmps.month += 1;
    cmps.day = 0;
    NSDate * date = [[NSCalendar currentCalendar] dateFromComponents:cmps];
    return date;
}

/// 当前月份总天数。基于当前日历，返回当前日期所在月份天数
- (NSUInteger)yp_dayInMonth {
    return [[self yp_lastDateInMomth] yp_day];
}

@end


@implementation NSDate (yp_DateAdding)
/// 以天为单位增减时间
- (NSDate *)yp_dateByAddingDay:(NSInteger)day {
    return [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:day toDate:self options:0];
}

/// 明天
- (NSDate *)yp_tomorrow {
    return [self yp_dateByAddingDay:1];
}

/// 昨天
- (NSDate *)yp_yesterday {
    return [self yp_dateByAddingDay:-1];
}

/// 以月为单位增减时间
- (NSDate *)yp_dateByAddingMonth:(NSInteger)value {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingUnit:NSCalendarUnitMonth value:value toDate:self options:0];
}

/// 下个月日期
- (NSDate *)yp_nextMonth {
    return [self yp_dateByAddingMonth:1];
}

/// 上个月日期
- (NSDate *)yp_previousMonth {
    return [self yp_dateByAddingMonth:-1];
}

@end
