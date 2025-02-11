//
//  CalculatorBridge.mm
//  Runner
//
//  Created by sprt on 2025/2/10.
//

@import LibQalculate;
#import "CalculatorBridge.h"

@implementation CalculatorBridge
- (instancetype)init {
    if(self = [super init]) {
        setlocale(LC_ALL, "zh_CN");
        new Calculator();
    }
    return self;
}

- (NSString *)parseCommand:(nonnull NSString *)command {
    MathStructure toParse = CALCULATOR->parse([command UTF8String]);
    toParse.format();
    return [NSString stringWithCString:toParse.print().c_str() encoding:[NSString defaultCStringEncoding]];
}

- (void)calculateCommand:(nonnull NSString *)command completion:(nonnull void (^)(CalcResult * _Nullable, FlutterError * _Nullable))completion {
    CALCULATOR->clearMessages();
    
    MathStructure result = CALCULATOR->calculate(CALCULATOR->unlocalizeExpression([command UTF8String]));
    CalculatorMessage *message = CALCULATOR->message();
    
    CalcResult *resultMsg = [CalcResult alloc];
    
    resultMsg.resultType = ResultTypeSuccess;
    if (message != nullptr) {
        switch (message->type()) {
            case MESSAGE_ERROR:
                resultMsg.resultType = ResultTypeFailure;
                break;
            case MESSAGE_WARNING:
                resultMsg.resultType = ResultTypeWarning;
                break;
            default:
                break;
        }
    }
    
    if (message == nullptr) {
        resultMsg.message = @"";
    } else {
        resultMsg.message = [NSString stringWithCString:message->message().c_str() encoding:[NSString defaultCStringEncoding]];
    }
    
    resultMsg.parsed = [self parseCommand:command];
    
    resultMsg.result = [NSString stringWithCString:result.print().c_str() encoding:[NSString defaultCStringEncoding]];
    
    completion(resultMsg, nullptr);

}

- (void)parseCommandCommand:(nonnull NSString *)command completion:(nonnull void (^)(NSString * _Nullable, FlutterError * _Nullable))completion { 
    NSString* toReturn = [self parseCommand:command];
    completion(toReturn, nullptr);
}

@end

