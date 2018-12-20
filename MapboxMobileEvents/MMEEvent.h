#import <Foundation/Foundation.h>

@class MMECommonEventData;

@interface MMEEvent : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSDictionary *attributes;

+ (instancetype)eventWithName:(NSString *)name attributes:(NSDictionary *)attributes;
+ (instancetype)turnstileEventWithAttributes:(NSDictionary *)attributes;
+ (instancetype)telemetryMetricsEventWithAttributes:(NSDictionary *)attributes;
+ (instancetype)locationEventWithAttributes:(NSDictionary *)attributes instanceIdentifer:(NSString *)instanceIdentifer commonEventData:(MMECommonEventData *)commonEventData;
+ (instancetype)visitEventWithAttributes:(NSDictionary *)attributes;
+ (instancetype)mapLoadEventWithCommonEventData:(MMECommonEventData *)commonEventData;
+ (instancetype)mapTapEventWithAttributes:(NSDictionary *)attributes;
+ (instancetype)mapDragEndEventWithAttributes:(NSDictionary *)attributes;
+ (instancetype)mapOfflineDownloadStartEventWithAttributes:(NSDictionary *)attributes;
+ (instancetype)mapOfflineDownloadEndEventWithAttributes:(NSDictionary *)attributes;
+ (instancetype)navigationEventWithName:(NSString *)name attributes:(NSDictionary *)attributes;
+ (instancetype)visionEventWithName:(NSString *)name attributes:(NSDictionary *)attributes;
+ (instancetype)debugEventWithAttributes:(NSDictionary *)attributes;
+ (instancetype)searchEventWithName:(NSString *)name attributes:(NSDictionary *)attributes;
+ (instancetype)carplayEventWithName:(NSString *)name attributes:(NSDictionary *)attributes;

@end
