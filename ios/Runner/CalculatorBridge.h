//
//  CalculatorBridge.h
//  Runner
//
//  Created by sprt on 2025/2/10.
//

@import LibQalculate;
#import "CalculatorBridge.g.h"
#import <Foundation/Foundation.h>

@interface CalculatorBridge : NSObject<CalculatorWrapper> {}
- (void)calculateCommand:(NSString *_Nonnull)command completion:(void (^_Nonnull)(CalcResult *_Nullable, FlutterError *_Nullable))completion;
- (void)parseCommandCommand:(NSString *_Nonnull)command completion:(void (^_Nonnull)(NSString *_Nullable, FlutterError *_Nullable))completion;
@end

