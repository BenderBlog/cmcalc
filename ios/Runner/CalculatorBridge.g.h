// Autogenerated from Pigeon (v22.7.4), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#import <Foundation/Foundation.h>

@protocol FlutterBinaryMessenger;
@protocol FlutterMessageCodec;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ResultType) {
  ResultTypeSuccess = 0,
  ResultTypeWarning = 1,
  ResultTypeFailure = 2,
};

/// Wrapper for ResultType to allow for nullability.
@interface ResultTypeBox : NSObject
@property(nonatomic, assign) ResultType value;
- (instancetype)initWithValue:(ResultType)value;
@end

@class CalcResult;

@interface CalcResult : NSObject
/// `init` unavailable to enforce nonnull fields, see the `make` class method.
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)makeWithResultType:(ResultType)resultType
    message:(NSString *)message
    parsed:(NSString *)parsed
    result:(NSString *)result;
@property(nonatomic, assign) ResultType resultType;
@property(nonatomic, copy) NSString * message;
@property(nonatomic, copy) NSString * parsed;
@property(nonatomic, copy) NSString * result;
@end

/// The codec used by all APIs.
NSObject<FlutterMessageCodec> *nullGetCalculatorBridgeCodec(void);

@protocol CalculatorWrapper
- (void)calculateCommand:(NSString *)command completion:(void (^)(CalcResult *_Nullable, FlutterError *_Nullable))completion;
- (void)parseCommandCommand:(NSString *)command completion:(void (^)(NSString *_Nullable, FlutterError *_Nullable))completion;
@end

extern void SetUpCalculatorWrapper(id<FlutterBinaryMessenger> binaryMessenger, NSObject<CalculatorWrapper> *_Nullable api);

extern void SetUpCalculatorWrapperWithSuffix(id<FlutterBinaryMessenger> binaryMessenger, NSObject<CalculatorWrapper> *_Nullable api, NSString *messageChannelSuffix);

NS_ASSUME_NONNULL_END
