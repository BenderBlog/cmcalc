//
//  CalendarBridge.h
//  Runner
//
//  Created by sprt on 2025/2/11.
//

@import LibQalculate;
#import "CalendarBridge.g.h"
#import <Foundation/Foundation.h>

/// **Must be called after the creation of the Calculator Object!**
@interface CalendarBridge : NSObject<CalendarWrapper> {}
@property QalculateDateTime date;
@property bool block_calendar_conversion;
- (void)setCalendarYearStem:(nullable NSNumber *)yearStem year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day calendarSystem:(CalendarSystemFromDart)calendarSystem completion:(void (^_Nonnull)(CalendarExecuteState *_Nullable, FlutterError *_Nullable))completion;
@end

