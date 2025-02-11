//
//  CalendarBridge.mm
//  Runner
//
//  Created by sprt on 2025/2/11.
//

@import LibQalculate;
#import "CalendarBridge.h"

@implementation CalendarBridge
- (instancetype)init {
    if(self = [super init]) {
        self.block_calendar_conversion = false;
        self.date.setToCurrentDate();
    }
    return self;
}


+ (CalendarSystemFromDart)translateSystemFromObjc:(CalendarSystem)ct {
    switch (ct) {
        case CALENDAR_MILANKOVIC:
            return CalendarSystemFromDartMilankovic;
            break;
        case CALENDAR_JULIAN:
            return CalendarSystemFromDartJulian;
            break;
        case CALENDAR_ISLAMIC:
            return CalendarSystemFromDartIslamic;
            break;
        case CALENDAR_HEBREW:
            return CalendarSystemFromDartHebrew;
            break;
        case CALENDAR_EGYPTIAN:
            return CalendarSystemFromDartEgyptian;
            break;
        case CALENDAR_PERSIAN:
            return CalendarSystemFromDartPersian;
            break;
        case CALENDAR_COPTIC:
            return CalendarSystemFromDartCoptic;
            break;
        case CALENDAR_ETHIOPIAN:
            return CalendarSystemFromDartEthiopian;
            break;
        case CALENDAR_INDIAN:
            return CalendarSystemFromDartIndian;
            break;
        case CALENDAR_CHINESE:
            return CalendarSystemFromDartChinese;
            break;
        default:
            return CalendarSystemFromDartGregorian;
            break;
    }
}

+ (CalendarSystem)translateSystemFromDart:(CalendarSystemFromDart)ct {
    switch (ct) {
        case CalendarSystemFromDartMilankovic:
            return CALENDAR_MILANKOVIC;
            break;
        case CalendarSystemFromDartJulian:
            return CALENDAR_JULIAN;
            break;
        case CalendarSystemFromDartIslamic:
            return CALENDAR_ISLAMIC;
            break;
        case CalendarSystemFromDartHebrew:
            return CALENDAR_HEBREW;
            break;
        case CalendarSystemFromDartEgyptian:
            return CALENDAR_EGYPTIAN;
            break;
        case CalendarSystemFromDartPersian:
            return CALENDAR_PERSIAN;
            break;
        case CalendarSystemFromDartCoptic:
            return CALENDAR_COPTIC;
            break;
        case CalendarSystemFromDartEthiopian:
            return CALENDAR_ETHIOPIAN;
            break;
        case CalendarSystemFromDartIndian:
            return CALENDAR_INDIAN;
            break;
        case CalendarSystemFromDartChinese:
            return CALENDAR_CHINESE;
            break;
        default: return CALENDAR_GREGORIAN;
    }
}


- (void)setCalendarYearStem:(nullable NSNumber *)yearStem year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day calendarSystem:(CalendarSystemFromDart)calendarSystem completion:(void (^_Nonnull)(CalendarExecuteState *_Nullable, FlutterError *_Nullable))completion {
    if (self.block_calendar_conversion) {
        completion([CalendarExecuteState
                    makeWithIsSuccess:false
                    message:@"Conversion ongoing."
                    data:@{}
                   ],nullptr);
        return;
    }
    self.block_calendar_conversion = true;
    
    long int y;
    if(calendarSystem == CalendarSystemFromDartChinese) {
        if (yearStem == nil) {
            completion([CalendarExecuteState
                        makeWithIsSuccess:false
                        message:@"Input Chinese Calendar but no stem year detected."
                        data:@{}
                       ],nullptr);
            self.block_calendar_conversion = false;
            return;

        }
        long int cy = [yearStem integerValue];
        
        if(cy <= 0) {
            completion([CalendarExecuteState
                        makeWithIsSuccess:false
                        message:@"The selected Chinese year does not exist."
                        data:@{}
                       ],nullptr);
            self.block_calendar_conversion = false;
            return;
        }
        y = chineseCycleYearToYear(79, cy);
    } else {
        y = year;
    }
    
    QalculateDateTime toUse;
    if(!calendarToDate(toUse,
                       y,
                       month,
                       day,
                       [CalendarBridge translateSystemFromDart:calendarSystem])) {
        self.block_calendar_conversion = false;
        completion([
            CalendarExecuteState
            makeWithIsSuccess:false
            message:@"Conversion to Gregorian calendar failed."
            data: @{}
            ],nullptr);
        return;
    }
    self.date = toUse;
    
    CalendarSystem cs;
    NSMutableDictionary<CalendarSystemFromDartBox *, NSArray<NSString *> *> *toReturn = [@{} mutableCopy];
    for(size_t i = 0; i < NUMBER_OF_CALENDARS; i++) {
        switch(i) {
            case 0: {cs = CALENDAR_GREGORIAN; break;}
            case 1: {cs = CALENDAR_HEBREW; break;}
            case 2: {cs = CALENDAR_ISLAMIC; break;}
            case 3: {cs = CALENDAR_PERSIAN; break;}
            case 4: {cs = CALENDAR_INDIAN; break;}
            case 5: {cs = CALENDAR_CHINESE; break;}
            case 6: {cs = CALENDAR_JULIAN; break;}
            case 7: {cs = CALENDAR_MILANKOVIC; break;}
            case 8: {cs = CALENDAR_COPTIC; break;}
            case 9: {cs = CALENDAR_ETHIOPIAN; break;}
            case 10: {cs = CALENDAR_EGYPTIAN; break;}
        }
        NSMutableArray<NSString *> *toReturnStringList = [NSMutableArray array];
        if(dateToCalendar(self.date, y, month, day, cs) &&
           y <= INT_MAX &&
           y >= INT_MIN &&
           month <= numberOfMonths(cs) && day <= 31) {
            if(cs == CALENDAR_CHINESE) {
                long int cy, yc, st, br;
                chineseYearInfo(y, cy, yc, st, br);
                [toReturnStringList addObject:[@((st - 1) / 2) stringValue]];
                [toReturnStringList addObject:[@(br - 1) stringValue]];
            } else {
                [toReturnStringList addObject:[@(y) stringValue]];
            }
            [toReturnStringList addObject:[@(month - 1) stringValue]];
            [toReturnStringList addObject:[@(day - 1) stringValue]];
        }
        ;
        [toReturn
         setObject: [toReturnStringList copy]
         forKey: [[CalendarSystemFromDartBox alloc]
                  initWithValue:[CalendarBridge
                                 translateSystemFromObjc:cs
                                ]]] ;
    }
    
    self.block_calendar_conversion = false;
    completion([CalendarExecuteState
                makeWithIsSuccess:true
                message:@""
                data: [toReturn copy]
               ],nullptr);
}

@end
