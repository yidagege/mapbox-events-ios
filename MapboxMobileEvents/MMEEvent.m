#import "MMEEvent.h"
#import "MMEConstants.h"
#import "MMECommonEventData.h"
#import "MMEReachability.h"
#import "MMENSDateWrapper.h"

@implementation MMEEvent

+ (instancetype)eventWithName:(NSString *)name attributes:(NSDictionary *)attributes {
    MMEEvent *event = [[MMEEvent alloc] init];
    event.name = name;
    NSMutableDictionary *commonAttributes = [NSMutableDictionary dictionary];
    commonAttributes[MMEEventKeyEvent] = event.name;
    commonAttributes[MMEEventKeyCreated] = [self formattedDateString];
    [commonAttributes addEntriesFromDictionary:attributes];
    event.attributes = commonAttributes;
    return event;
}

+ (instancetype)turnstileEventWithAttributes:(NSDictionary *)attributes {
    MMEEvent *turnstileEvent = [[MMEEvent alloc] init];
    turnstileEvent.name = MMEEventTypeAppUserTurnstile;
    turnstileEvent.attributes = attributes;
    return turnstileEvent;
}

+ (instancetype)telemetryMetricsEventWithAttributes:(NSDictionary *)attributes {
    MMEEvent *telemetryMetrics = [[MMEEvent alloc] init];
    telemetryMetrics.name = MMEEventTypeTelemetryMetrics;
    NSMutableDictionary *commonAttributes = [NSMutableDictionary dictionary];
    commonAttributes[MMEEventKeyEvent] = telemetryMetrics.name;
    commonAttributes[MMEEventKeyCreated] = [self formattedDateString];
    [commonAttributes addEntriesFromDictionary:attributes];
    telemetryMetrics.attributes = attributes;
    return telemetryMetrics;
}

+ (instancetype)locationEventWithAttributes:(NSDictionary *)attributes instanceIdentifer:(NSString *)instanceIdentifer commonEventData:(MMECommonEventData *)commonEventData {

    MMEEvent *locationEvent = [[MMEEvent alloc] init];
    locationEvent.name = MMEEventTypeLocation;
    NSMutableDictionary *commonAttributes = [NSMutableDictionary dictionary];
    commonAttributes[MMEEventKeyEvent] = locationEvent.name;
    commonAttributes[MMEEventKeySource] = MMEEventSource;
    commonAttributes[MMEEventKeySessionId] = instanceIdentifer;
    commonAttributes[MMEEventKeyOperatingSystem] = commonEventData.iOSVersion;
    NSString *applicationState = [commonEventData applicationState];
    if (![applicationState isEqualToString:MMEApplicationStateUnknown]) {
        commonAttributes[MMEEventKeyApplicationState] = applicationState;
    }
    [commonAttributes addEntriesFromDictionary:attributes];
    locationEvent.attributes = commonAttributes;
    return locationEvent;
}

+ (instancetype)visitEventWithAttributes:(NSDictionary *)attributes {
    MMEEvent *visitEvent = [[MMEEvent alloc] init];
    visitEvent.name = MMEEventTypeVisit;
    NSMutableDictionary *commonAttributes = [NSMutableDictionary dictionary];
    commonAttributes[MMEEventKeyEvent] = visitEvent.name;
    [commonAttributes addEntriesFromDictionary:attributes];
    visitEvent.attributes = commonAttributes;
    return visitEvent;
}

+ (instancetype)mapLoadEventWithCommonEventData:(MMECommonEventData *)commonEventData; {
    MMEEvent *mapLoadEvent = [[MMEEvent alloc] init];
    mapLoadEvent.name = MMEEventTypeMapLoad;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[MMEEventKeyEvent] = mapLoadEvent.name;
    attributes[MMEEventKeyCreated] = [self formattedDateString];
    attributes[MMEEventKeyVendorID] = commonEventData.vendorId;
    attributes[MMEEventKeyModel] = commonEventData.model;
    attributes[MMEEventKeyOperatingSystem] = commonEventData.iOSVersion;
    attributes[MMEEventKeyResolution] = @(commonEventData.scale);
    attributes[MMEEventKeyAccessibilityFontScale] = @([self contentSizeScale]);
    attributes[MMEEventKeyOrientation] = [self deviceOrientation];
    attributes[MMEEventKeyWifi] = @([[MMEReachability reachabilityForLocalWiFi] isReachableViaWiFi]);
    mapLoadEvent.attributes = attributes;
    return mapLoadEvent;
}

+ (instancetype)mapTapEventWithAttributes:(NSDictionary *)attributes {
    MMEEvent *mapTapEvent = [[MMEEvent alloc] init];
    mapTapEvent.name = MMEEventTypeMapTap;
    NSMutableDictionary *commonAttributes = [NSMutableDictionary dictionary];
    commonAttributes[MMEEventKeyEvent] = mapTapEvent.name;
    commonAttributes[MMEEventKeyCreated] = [self formattedDateString];
    commonAttributes[MMEEventKeyOrientation] = [self deviceOrientation];
    commonAttributes[MMEEventKeyWifi] = @([[MMEReachability reachabilityForLocalWiFi] isReachableViaWiFi]);
    [commonAttributes addEntriesFromDictionary:attributes];
    mapTapEvent.attributes = commonAttributes;
    return mapTapEvent;
}

+ (instancetype)mapDragEndEventWithAttributes:(NSDictionary *)attributes {
    MMEEvent *mapTapEvent = [[MMEEvent alloc] init];
    mapTapEvent.name = MMEEventTypeMapDragEnd;
    NSMutableDictionary *commonAttributes = [NSMutableDictionary dictionary];
    commonAttributes[MMEEventKeyEvent] = mapTapEvent.name;
    commonAttributes[MMEEventKeyCreated] = [self formattedDateString];
    commonAttributes[MMEEventKeyOrientation] = [self deviceOrientation];
    commonAttributes[MMEEventKeyWifi] = @([[MMEReachability reachabilityForLocalWiFi] isReachableViaWiFi]);
    [commonAttributes addEntriesFromDictionary:attributes];
    mapTapEvent.attributes = commonAttributes;
    return mapTapEvent;
}

+ (instancetype)mapOfflineDownloadStartEventWithAttributes:(NSDictionary *)attributes {
    MMEEvent *mapOfflineDownloadEvent = [[MMEEvent alloc] init];
    mapOfflineDownloadEvent.name = MMEventTypeOfflineDownloadStart;
    NSMutableDictionary *commonAttributes = [NSMutableDictionary dictionary];
    commonAttributes[MMEEventKeyEvent] = mapOfflineDownloadEvent.name;
    commonAttributes[MMEEventKeyCreated] = [self formattedDateString];
    [commonAttributes addEntriesFromDictionary:attributes];
    mapOfflineDownloadEvent.attributes = commonAttributes;
    return mapOfflineDownloadEvent;
}

+ (instancetype)mapOfflineDownloadEndEventWithAttributes:(NSDictionary *)attributes {
    MMEEvent *mapOfflineDownloadEvent = [[MMEEvent alloc] init];
    mapOfflineDownloadEvent.name = MMEventTypeOfflineDownloadEnd;
    NSMutableDictionary *commonAttributes = [NSMutableDictionary dictionary];
    commonAttributes[MMEEventKeyEvent] = mapOfflineDownloadEvent.name;
    commonAttributes[MMEEventKeyCreated] = [self formattedDateString];
    [commonAttributes addEntriesFromDictionary:attributes];
    mapOfflineDownloadEvent.attributes = commonAttributes;
    return mapOfflineDownloadEvent;
}

+ (instancetype)navigationEventWithName:(NSString *)name attributes:(NSDictionary *)attributes {
    MMEEvent *navigationEvent = [[MMEEvent alloc] init];
    navigationEvent.name = name;
    navigationEvent.attributes = attributes;
    return navigationEvent;
}

+ (instancetype)visionEventWithName:(NSString *)name attributes:(NSDictionary *)attributes {
    MMEEvent *visionEvent = [[MMEEvent alloc] init];
    visionEvent.name = name;
    NSMutableDictionary *commonAttributes = [NSMutableDictionary dictionary];
    commonAttributes[MMEEventKeyEvent] = visionEvent.name;
    [commonAttributes addEntriesFromDictionary:attributes];
    visionEvent.attributes = commonAttributes;
    return visionEvent;
}

+ (instancetype)debugEventWithAttributes:(NSDictionary *)attributes {
    MMEEvent *debugEvent = [[MMEEvent alloc] init];
    debugEvent.name = MMEEventTypeLocalDebug;
    debugEvent.attributes = [attributes copy];
    return debugEvent;
}

+ (instancetype)searchEventWithName:(NSString *)name attributes:(NSDictionary *)attributes {
    MMEEvent *searchEvent = [[MMEEvent alloc] init];
    searchEvent.name = name;
    NSMutableDictionary *commonAttributes = [NSMutableDictionary dictionary];
    commonAttributes[MMEEventKeyEvent] = searchEvent.name;
    [commonAttributes addEntriesFromDictionary:attributes];
    searchEvent.attributes = commonAttributes;
    return searchEvent;
}

+ (instancetype)carplayEventWithName:(NSString *)name attributes:(NSDictionary *)attributes {
    MMEEvent *carplayEvent = [[MMEEvent alloc] init];
    carplayEvent.name = name;
    NSMutableDictionary *commonAttributes = [NSMutableDictionary dictionary];
    commonAttributes[MMEEventKeyEvent] = carplayEvent.name;
    [commonAttributes addEntriesFromDictionary:attributes];
    carplayEvent.attributes = commonAttributes;
    return carplayEvent;
}

+ (MMECommonEventData *)commonEventData {
    MMECommonEventData *commonEventData = [[MMECommonEventData alloc] init];
    return commonEventData;
}

+ (NSInteger)contentSizeScale {
    NSInteger result = -9999;
    
    NSString *sc = [UIApplication sharedApplication].preferredContentSizeCategory;
    
    if ([sc isEqualToString:UIContentSizeCategoryExtraSmall]) {
        result = -3;
    } else if ([sc isEqualToString:UIContentSizeCategorySmall]) {
        result = -2;
    } else if ([sc isEqualToString:UIContentSizeCategoryMedium]) {
        result = -1;
    } else if ([sc isEqualToString:UIContentSizeCategoryLarge]) {
        result = 0;
    } else if ([sc isEqualToString:UIContentSizeCategoryExtraLarge]) {
        result = 1;
    } else if ([sc isEqualToString:UIContentSizeCategoryExtraExtraLarge]) {
        result = 2;
    } else if ([sc isEqualToString:UIContentSizeCategoryExtraExtraExtraLarge]) {
        result = 3;
    } else if ([sc isEqualToString:UIContentSizeCategoryAccessibilityMedium]) {
        result = -11;
    } else if ([sc isEqualToString:UIContentSizeCategoryAccessibilityLarge]) {
        result = 10;
    } else if ([sc isEqualToString:UIContentSizeCategoryAccessibilityExtraLarge]) {
        result = 11;
    } else if ([sc isEqualToString:UIContentSizeCategoryAccessibilityExtraExtraLarge]) {
        result = 12;
    } else if ([sc isEqualToString:UIContentSizeCategoryAccessibilityExtraExtraExtraLarge]) {
        result = 13;
    }
    
    return result;
}

+ (NSString *)deviceOrientation {
    NSString *result;
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationUnknown:
            result = @"Unknown";
            break;
        case UIDeviceOrientationPortrait:
            result = @"Portrait";
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            result = @"PortraitUpsideDown";
            break;
        case UIDeviceOrientationLandscapeLeft:
            result = @"LandscapeLeft";
            break;
        case UIDeviceOrientationLandscapeRight:
            result = @"LandscapeRight";
            break;
        case UIDeviceOrientationFaceUp:
            result = @"FaceUp";
            break;
        case UIDeviceOrientationFaceDown:
            result = @"FaceDown";
            break;
        default:
            result = @"Default - Unknown";
            break;
    }
    return result;
}

+ (NSString *)formattedDateString {
    MMENSDateWrapper *dateWrapper = [[MMENSDateWrapper alloc] init];
    return [dateWrapper formattedDateStringForDate:[dateWrapper date]];
}

- (BOOL)isEqualToEvent:(MMEEvent *)event {
    if (!event) {
        return NO;
    }
    
    BOOL hasEqualName = [self.name isEqualToString:event.name];
    BOOL hasEqualAttributes = [self.attributes isEqual:event.attributes];
    
    return hasEqualName && hasEqualAttributes;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    
    if (![other isKindOfClass:[MMEEvent class]]) {
        return  NO;
    }
    
    return [self isEqualToEvent:other];
}

- (NSUInteger)hash {
    return self.name.hash ^ self.attributes.hash;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ name=%@, attributes=%@>", NSStringFromClass([self class]), self.name, self.attributes];
}

@end
