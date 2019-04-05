#import "MMEDateFakes.h"

typedef enum {
    MMEDateFakeEarlier = 1,
    MMEDateFakeLater = 2,
    MMEDateFakeWhenever = 3,
    MMEDateFakeNever =4
} MMEDateFakeType;

@interface MMEDateFakes ()
@property(nonatomic,assign) MMEDateFakeType fakeType;

@end

#pragma mark -

@implementation MMEDateFakes

+ (MMEDate *)earlier {
    MMEDateFakes *faked = MMEDateFakes.date;
    faked.fakeType = MMEDateFakeEarlier;
    return faked;
}

+ (MMEDate *)later {
    MMEDateFakes *faked = MMEDateFakes.date;
    faked.fakeType = MMEDateFakeLater;
    return faked;
}

+ (MMEDate *)whenever {
    MMEDateFakes *faked = MMEDateFakes.date;
    faked.fakeType = MMEDateFakeWhenever;
    return faked;
}

+ (MMEDate *)never{
    MMEDateFakes *faked = MMEDateFakes.date;
    faked.fakeType = MMEDateFakeNever;
    return faked;
}

#pragma mark - NSDate Overrides

- (BOOL) isEqualToDate:(NSDate *)date {
    BOOL isEqual = NO;

    switch (self.fakeType) {
        case MMEDateFakeEarlier:
            isEqual = (date.timeIntervalSinceReferenceDate <= self.timeIntervalSinceReferenceDate);
            break;

        case MMEDateFakeLater:
            isEqual = (date.timeIntervalSinceReferenceDate >= self.timeIntervalSinceReferenceDate);
            break;

        case MMEDateFakeWhenever:
            isEqual = YES;
            break;

        case MMEDateFakeNever:
            isEqual = NO;
            break;

        default:
            isEqual = [super isEqualToDate:date];
            break;
    }

    return isEqual;
}

- (NSComparisonResult) compare:(NSDate *)date {
    NSComparisonResult comprable = NSOrderedSame;

    switch (self.fakeType) {
        case MMEDateFakeEarlier:
            comprable = (date.timeIntervalSinceReferenceDate < self.timeIntervalSinceReferenceDate) ? NSOrderedSame : NSOrderedAscending;
            break;

        case MMEDateFakeLater:
            comprable = (date.timeIntervalSinceReferenceDate > self.timeIntervalSinceReferenceDate) ? NSOrderedSame : NSOrderedDescending;
            break;

        case MMEDateFakeWhenever:
            comprable = NSOrderedSame; // it's always whenever
            break;

        case MMEDateFakeNever:
            comprable = NSOrderedDescending; // never is always later
            break;

        default:
            comprable = [super compare:date];
            break;
    }

    return comprable;
}

@end
