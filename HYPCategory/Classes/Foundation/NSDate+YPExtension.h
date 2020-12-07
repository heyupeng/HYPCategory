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

@end


@interface NSDate (yp_Creation)

+ (NSDate *)yp_dateFromString:(NSString *)string format:(NSString *)fmt;

+ (NSDate *)yp_dateWithYear:(int)year month:(int)month day:(int)day;

@end


typedef NSString *NSDateFromatKey;

@interface NSDate (yp_DateFormat)

FOUNDATION_EXPORT const NSDateFromatKey NSDateFormatDateAndTimeKey;
FOUNDATION_EXPORT const NSDateFromatKey NSDateFormatDateKey;
FOUNDATION_EXPORT const NSDateFromatKey NSDateFormatTimeKey;

- (NSString *)yp_format:(NSString *)format;

@end


@interface NSDate (yp_Description)

- (NSString *)yp_description;

- (NSString *)yp_short_description;

@end


@interface NSDate (yp_DateComponents)

- (NSDateComponents *)yp_dateComponents;

- (NSDateComponents *)yp_dateComponentsWithUnit:(NSCalendarUnit)unitFlags;

- (NSUInteger)yp_year;

- (NSUInteger)yp_month;

- (NSUInteger)yp_day;

- (NSInteger)yp_weekday;

@end


@interface NSDate (yp_Extension)

- (NSDate *)yp_midnight;

- (NSDate *)yp_startDateInDay;

- (NSDate *)yp_endDateInday;

- (NSDate *)yp_firstDateInMomth;

- (NSDate *)yp_lastDateInMomth;

- (NSUInteger)yp_dayInMonth;

@end


@interface NSDate (yp_DateAdding)

- (NSDate *)yp_dateByAddingDay:(NSInteger)day;

- (NSDate *)yp_yesterday;

- (NSDate *)yp_tomorrow;

- (NSDate *)yp_dateByAddingMonth:(NSInteger)value;

- (NSDate *)yp_previousMonth;

- (NSDate *)yp_nextMonth;

@end

NS_ASSUME_NONNULL_END
