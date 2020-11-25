//
//  NSDate+YPExtension.m
//  YPDemo
//
//  Created by MAC on 2019/12/4.
//  Copyright © 2019 heyupeng. All rights reserved.
//

#import "NSDate+YPExtension.h"

@implementation NSDate (YPExtension)

/**
 * 以天为单位增减时间
 */
- (NSDate *)yp_dateByAddingDay:(NSInteger)day {
    return [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:day toDate:self options:0];
}

- (NSDate *)yp_tomorrow {
    return [self yp_dateByAddingDay:1];
}

- (NSDate *)yp_yesterday {
    return [self yp_dateByAddingDay:-1];
}

/**
 * 以月为单位增减时间
 */
- (NSDate *)yp_dateByAddingMonth:(NSInteger)value {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingUnit:NSCalendarUnitMonth value:value toDate:self options:0];
}

- (NSDate *)yp_nextMonth {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:self options:0];
}

- (NSDate *)yp_previousMonth {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:self options:0];
}

/**
 * 当前日期所在月份天数
 */
- (NSUInteger)yp_countInMonth {
    NSDate * date = self;
    NSCalendar * calenar = [NSCalendar currentCalendar];
    
    NSRange range = [calenar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

/**
 * 当前日期所在月份日期集
 */
- (NSArray <NSDate *>*)yp_datesInMonth {
    NSDate * date = self;
    NSCalendar * calenar = [NSCalendar currentCalendar];
    
    NSRange range = [calenar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSCalendarUnit flags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday;
    NSDateComponents * dateComponents = [calenar components:flags fromDate:date];
    
    NSMutableArray * monthMap = [[NSMutableArray alloc] initWithCapacity:42];
    for (int i = 1; i <= range.length; i++) {
        dateComponents.day = i;
        NSDate * date_ = [calenar dateFromComponents:dateComponents];
        [monthMap addObject: date_];
    }
    return monthMap;
}

/**
 * 当前日期组成（年、月、日、星期、当月周序列）
 */
- (NSDateComponents *)yp_dateComponents {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSCalendarUnit flags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday|NSCalendarUnitWeekdayOrdinal;
    return [calendar components:flags fromDate:self];
}

- (NSDateComponents *)yp_dateComponentsWith:(NSCalendarUnit)unitFlags  {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    return [calendar components:unitFlags fromDate:self];
}

@end

@implementation NSDate (yp_Creation)

/**
 * 通过格式化创建 NSDate
 */
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

@implementation NSDate (yp_Format)
const NSString * NSDateShortFormatKey = @"yyyy-MM-dd";
const NSString * NSDateLongFormatKey = @"yyyy-MM-dd HH:mm:ss";
const NSString * NSDateFullFormatKey = @"yyyy-MM-dd HH:mm:ss.S Z";
const NSString * NSDateHourFormatKey = @"HH:mm:ss";

/// 日期格式化（本地时区）
/// @param format 格式 ("yyyy-MM-dd", "HH:mm:ss.S", "Z" )
- (NSString *)yp_format:(NSString *)format {
    static NSDateFormatter * dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
    }
    
    if (format) {
        dateFormatter.dateFormat = format;
    }
    
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:self];
}

@end

static NSDateFormatter * dateFormatter_;

@implementation NSDate (yp_Description)

- (NSString *)yp_description {
    if (!dateFormatter_) {
        dateFormatter_ = [[NSDateFormatter alloc] init];
        [dateFormatter_ setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS Z"];
    }
    return [dateFormatter_ stringFromDate:self];
}

@end


@implementation NSDate (yp_Festival)
/*
 农历节日
 0101: "春节 ",
 0115: "元宵节",
 0202: "龙头节",
 0303: "上巳节",
 0505: "端午节",
 0707: "七夕节",
 0715: "中元节",
 0815: "中秋节",
 0909: "重阳节",
 1001: "寒衣节",
 1015: "下元节",
 1208: "腊八节",
 1223: "小年",
 */
- (NSString *)yp_festival {
    NSDateComponents * components;
    
    NSArray * lunar_festivals = @[
        @{@"format": @"0101", @"value": @"春节"},
        @{@"format": @"0115", @"value": @"元宵节"},
        @{@"format": @"0202", @"value": @"龙头节"},
        @{@"format": @"0303", @"value": @"上巳节"},
        @{@"format": @"0505", @"value": @"端午节"},
        @{@"format": @"0707", @"value": @"七夕节"},
        @{@"format": @"0715", @"value": @"中元节"},
        @{@"format": @"0815", @"value": @"中秋节"},
        @{@"format": @"0909", @"value": @"重阳节"},
        @{@"format": @"1001", @"value": @"寒衣节"},
        @{@"format": @"1015", @"value": @"下元节"},
        @{@"format": @"1208", @"value": @"腊八节"},
        @{@"format": @"1223", @"value": @"小年"},
    ];
    
    components = [self yp_chineseComponents];
    NSInteger chineseMonth, chineseDay;
    chineseMonth = components.month; chineseDay = components.day;
    
    if (chineseMonth == 12) {
        NSInteger count = [self yp_chineseCountInMonth];
        if (chineseDay == count) return @"除夕";
    }
    for (NSDictionary * item in lunar_festivals) {
        NSString * format = [item objectForKey:@"format"];
        if ([[format substringToIndex:2] integerValue] == chineseMonth && [[format substringFromIndex:2] integerValue] == chineseDay) {
            return [item objectForKey:@"value"];
        }
    }
    
    components = [self yp_dateComponents];
    
    NSArray * festivals = @[
        @{@"month": @"1", @"day": @"1", @"value": @"元旦"},
        @{@"month": @"", @"day": @"", @"value": @""},
        
        @{@"month": @2, @"day": @2, @"value": @"湿地日"},
        @{@"month": @2, @"day": @14, @"value": @"情人节"},
        
        @{@"month": @3, @"day": @3, @"value": @"全国爱耳日"},
        @{@"month": @3, @"day": @5, @"value": @"学雷锋日"},
        @{@"month": @3, @"day": @8, @"value": @"妇女节"},
        @{@"month": @3, @"day": @12, @"value": @"植树节"},
        @{@"month": @3, @"day": @15, @"value": @"消费者日"},
//        @{@"month": @3, @"day": @23, @"value": @"世界气象日"},
        
        @{@"month": @4, @"day": @1, @"value": @"愚人节"},
        @{@"month": @4, @"day": @5, @"value": @"清明节"},
        
        @{@"month": @5, @"day": @1, @"value": @"劳动节"},
        @{@"month": @5, @"day": @4, @"value": @"青年节"},
        
        @{@"month": @6, @"day": @1, @"value": @"儿童节"},
        @{@"month": @7, @"day": @1, @"value": @"建军节"},
        @{@"month": @8, @"day": @1, @"value": @"建党节"},
        @{@"month": @9, @"day": @10, @"value": @"教师节"},
        @{@"month": @10, @"day": @1, @"value": @"国庆节"},
        @{@"month": @12, @"day": @13, @"value": @"国家公祭日"},
        
        @{@"month": @5, @"weekday": @1, @"weekdayOrdinal": @2, @"value": @"母亲节"},
        @{@"month": @6, @"weekday": @1, @"weekdayOrdinal": @3, @"value": @"父亲节"},
    ];
    
    for (NSDictionary * item in festivals) {
        if (components.month != [[item objectForKey:@"month"] intValue]) {
            continue;
        }
        if (components.day == [[item objectForKey:@"day"] intValue]) {
            return [item objectForKey:@"value"];
        }
        if (components.weekday == [[item objectForKey:@"weekday"] intValue] && components.weekdayOrdinal == [[item objectForKey:@"weekdayOrdinal"] intValue]) {
            return [item objectForKey:@"value"];
        }
    }
    
    return nil;
}

@end


@implementation NSDate (yp_Chinese_calendar)

static NSArray * yp_chinese_zodiacSymbols;
static NSArray * yp_chinese_yearSymbols;
static NSArray * yp_chinese_monthSymbols;
static NSArray * yp_chinese_daySymbols;

- (NSArray *)chineseZodiacSymbols {
    if (!yp_chinese_zodiacSymbols) {
        NSArray * zodiac = @[@"鼠", @"牛", @"虎", @"兔", @"龙", @"蛇", @"马", @"羊", @"猴", @"鸡", @"狗", @"猪"]; // 生肖
        yp_chinese_zodiacSymbols = zodiac;
    }
    return yp_chinese_zodiacSymbols;
}

- (NSArray *)chineseYearSymbols {
    if (yp_chinese_yearSymbols) { return yp_chinese_yearSymbols;}
    
    NSString * HeavenlyStems = @"甲乙丙丁戊己庚辛壬癸"; // 天干
    NSString * EarthlyBranches = @"子丑寅卯辰己午未申酉戌亥"; // 地支
    NSMutableArray * chinese_yearSymbols = [[NSMutableArray alloc] initWithCapacity:60];
    for (int i = 0; i < 60; i += 1) {
        NSInteger stem = i % HeavenlyStems.length;
        NSInteger branch = i % EarthlyBranches.length;
        NSString * y = [[HeavenlyStems substringWithRange:NSMakeRange(stem, 1)] stringByAppendingString:[EarthlyBranches substringWithRange:NSMakeRange(branch, 1)]];
        [chinese_yearSymbols addObject:y];
    }
    yp_chinese_yearSymbols = chinese_yearSymbols;
    return chinese_yearSymbols;
}

- (NSArray *)chineseMonthSymbols {
    return @[@"正", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十", @"冬", @"腊"];
}

- (NSArray *)chineseDaySymbols {
    return @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
             @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
             @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",];
}

static NSCalendar * _yp_chinese_calendar_;
- (NSCalendar *)chineseCalendar {
    if (!_yp_chinese_calendar_) {
        NSCalendar * chinese_calendar;
        chinese_calendar= [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
        chinese_calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
        _yp_chinese_calendar_ = chinese_calendar;
    }
    return _yp_chinese_calendar_;
}

- (NSDateComponents *)yp_chineseComponents {
    NSCalendar * chinese_calendar = [self chineseCalendar];
    NSCalendarUnit flags = NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitDay;
    NSDateComponents *  componenets = [chinese_calendar components:flags fromDate:self];
    return componenets;
}

- (NSUInteger)yp_chineseCountInMonth {
    NSDate * date = self;
    NSCalendar * calenar = [self chineseCalendar];
    
    NSRange range = [calenar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

- (NSString *)yp_chineseFormat:(NSString *)fmt {
    // Symbol
    NSArray * chinese_yearSymbols = [self chineseYearSymbols];
    NSArray * chinese_monthSymbols = [self chineseMonthSymbols];
    NSArray * chinese_daySymbols = [self chineseDaySymbols];
    NSString * leapSymbol = @"闰";
    
    NSString * dateFormat = @"r y(Z) LMM dd";
    if (fmt) {dateFormat = fmt;}
    
    NSCalendar * chinese_calendar = [self chineseCalendar];;
    NSCalendarUnit flags = NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitDay;
    NSDateComponents *  componenets = [chinese_calendar components:flags fromDate:self];
    NSInteger year = componenets.year, month = componenets.month, day = componenets.day;
    BOOL leapMonth = componenets.leapMonth;
    NSInteger zodiacIndex = (year - 1) % 12;
    
    // 自定义格式化覆盖
    NSDictionary * dict = @{
        @"y+": year <= chinese_yearSymbols.count ? [chinese_yearSymbols objectAtIndex:year - 1]: [@(year) stringValue],
        @"Z+": zodiacIndex < [self chineseZodiacSymbols].count ? [[self chineseZodiacSymbols] objectAtIndex:zodiacIndex]: @"",
        @"L+": leapMonth? leapSymbol: @"", // 记作闰月标识
        @"M+": month <= chinese_monthSymbols.count ? [chinese_monthSymbols objectAtIndex:month - 1]: [@(month) stringValue],
        @"d+": day <= chinese_daySymbols.count ? [chinese_daySymbols objectAtIndex:day - 1] :[@(day) stringValue],
    };
    
    NSError * error; NSRegularExpression * RE;
//    NSString * pattern;
//    RE= [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
//    [RE matchesInString:dateFormat options:NSMatchingReportCompletion range:NSMakeRange(0, dateFormat.length)];
    
    for (NSString * key in dict.allKeys) {
        RE = [NSRegularExpression regularExpressionWithPattern:key options:0 error:& error];
        if (error || !RE) {continue;}
        NSString * template = [dict objectForKey:key];
        dateFormat = [RE stringByReplacingMatchesInString:dateFormat options:0 range:NSMakeRange(0, dateFormat.length) withTemplate:template];
    }
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    df.calendar = chinese_calendar;
    df.shortMonthSymbols = chinese_monthSymbols;
    df.dateFormat = dateFormat;
    return [df stringFromDate:self];
}

- (NSString *)yp_chinese_description {
    
    NSString * dateFormat = @"r(yZ)年 LMM月dd";
    return [self yp_chineseFormat:dateFormat];
}

@end
