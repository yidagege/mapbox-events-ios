#import <XCTest/XCTest.h>
#import "MMEAPIClient.h"
#import "MMEConstants.h"
#import "MMEEvent.h"
#import "MMECommonEventData.h"

#import "MMENSURLSessionWrapperFake.h"

@interface MMEAPIClientTests : XCTestCase

@property (nonatomic) MMEAPIClient *apiClient;

@end

@interface MMEAPIClient (Tests)

@property (nonatomic) id<MMENSURLSessionWrapper> sessionWrapper;
@property (nonatomic, copy) NSData *digicertCert;
@property (nonatomic, copy) NSData *geoTrustCert;
@property (nonatomic, copy) NSData *testServerCert;
@property (nonatomic, copy) NSURL *baseURL;
@property (nonatomic) BOOL usesTestServer;
@property (nonatomic) NSBundle *applicationBundle;
@property (nonatomic, copy) NSString *userAgent;

- (void)setupUserAgent;

@end

@implementation MMEAPIClientTests

- (void)setUp {
    [super setUp];
    self.apiClient = [[MMEAPIClient alloc] init];
}

- (void)testInitialization {
    XCTAssertNotNil(self.apiClient.sessionWrapper);

    [self loadAndCheckCertificateWithName:@"api_mapbox_com-digicert" comparedToAPIClientCertificate:self.apiClient.digicertCert];
    [self loadAndCheckCertificateWithName:@"api_mapbox_com-geotrust" comparedToAPIClientCertificate:self.apiClient.geoTrustCert];
    [self loadAndCheckCertificateWithName:@"api_mapbox_staging" comparedToAPIClientCertificate:self.apiClient.testServerCert];
}

- (void)testSettingUpBaseURL {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MMETelemetryTestServerURL];
    self.apiClient = [[MMEAPIClient alloc] init];

    XCTAssertEqualObjects([NSURL URLWithString:MMEAPIClientBaseURL], self.apiClient.baseURL);
}

- (void)testSettingBaseURLWithTestServer {
    NSString *testURLString = @"https://test.com";
    [[NSUserDefaults standardUserDefaults] setObject:testURLString forKey:MMETelemetryTestServerURL];
    self.apiClient = [[MMEAPIClient alloc] init];

    XCTAssertTrue(self.apiClient.usesTestServer);
    XCTAssertEqualObjects(self.apiClient.baseURL, [NSURL URLWithString:testURLString]);

    NSString *testURLStringBad = @"http://test.com";
    [[NSUserDefaults standardUserDefaults] setObject:testURLStringBad forKey:MMETelemetryTestServerURL];
    self.apiClient = [[MMEAPIClient alloc] init];

    XCTAssertFalse(self.apiClient.usesTestServer);
    XCTAssertEqualObjects([NSURL URLWithString:MMEAPIClientBaseURL], self.apiClient.baseURL);

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MMETelemetryTestServerURL];
}

- (void)testSettingUpUserAgent {
    NSBundle *fakeApplicationBundle = [NSBundle bundleForClass:[MMEAPIClientTests class]];
    NSBundle *sdkBundle = [NSBundle bundleForClass:[MMEAPIClient class]];

    self.apiClient.applicationBundle = fakeApplicationBundle;
    [self.apiClient setupUserAgent];

    NSString *appName = [fakeApplicationBundle objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    NSString *appVersion = [fakeApplicationBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *appBuildNumber = [fakeApplicationBundle objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *shortVersion = [sdkBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

    NSString *expectedUserAgent = [NSString stringWithFormat:@"%@/%@/%@ %@/%@", appName, appVersion, appBuildNumber, MMEAPIClientUserAgentBase, shortVersion];
    XCTAssertEqualObjects(expectedUserAgent, self.apiClient.userAgent);
}

- (void)testPostingAnEventWithNoError {
    XCTestExpectation *expectation = [self expectationWithDescription:@"It should call the completion handler"];

    MMENSURLSessionWrapperFake *sessionWrapperFake = [[MMENSURLSessionWrapperFake alloc] init];
    self.apiClient.sessionWrapper = sessionWrapperFake;

    MMECommonEventData *commonEventData = [[MMECommonEventData alloc] init];
    commonEventData.vendorId = @"vendor-id";
    commonEventData.model = @"model";
    commonEventData.iOSVersion = @"1";
    commonEventData.scale = 42;
    MMEEvent *event = [MMEEvent locationEventWithAttributes:@{} instanceIdentifer:@"instance-id-1" commonEventData:commonEventData];

    [self.apiClient postEvent:event completionHandler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];

    // It should tell its session wrapper to process a request with a completion handler
    XCTAssertTrue([sessionWrapperFake received:@selector(processRequest:completionHandler:)]);

    // The request should be correct
    XCTAssertEqualObjects(sessionWrapperFake.request.URL.absoluteString, @"https://events.mapbox.com/events/v2?access_token=(null)");
    XCTAssertEqualObjects(sessionWrapperFake.request.allHTTPHeaderFields[MMEAPIClientHeaderFieldUserAgentKey], self.apiClient.userAgent);
    XCTAssertEqualObjects(sessionWrapperFake.request.allHTTPHeaderFields[MMEAPIClientHeaderFieldContentTypeKey], MMEAPIClientHeaderFieldContentTypeValue);
    XCTAssertEqualObjects(sessionWrapperFake.request.HTTPMethod, MMEAPIClientHTTPMethodPost);

    XCTAssertNil(sessionWrapperFake.request.allHTTPHeaderFields[MMEAPIClientHeaderFieldContentEncodingKey]);
    XCTAssertEqualObjects(sessionWrapperFake.request.HTTPBody, [self jsonDataForEvents:@[event]]);


    // When the session wrapper returns with a status code < 400
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http:test.com"]
                                                              statusCode:200
                                                             HTTPVersion:nil
                                                            headerFields:nil];
    [sessionWrapperFake completeProcessingWithData:nil response:response error:nil];

    // It should complete the post event with no error
    [self waitForExpectations:@[expectation] timeout:1];

}

#pragma mark - Utilities

- (NSData *)jsonDataForEvents:(NSArray *)events {
    NSMutableArray *eventAttributes = [NSMutableArray arrayWithCapacity:events.count];
    [events enumerateObjectsUsingBlock:^(MMEEvent * _Nonnull event, NSUInteger idx, BOOL * _Nonnull stop) {
        if (event.attributes) {
            [eventAttributes addObject:event.attributes];
        }
    }];
    return [NSJSONSerialization dataWithJSONObject:eventAttributes options:0 error:nil];
}

- (void)loadAndCheckCertificateWithName:(NSString *)name comparedToAPIClientCertificate:(NSData *)APIClientCertificate {
    NSBundle *bundle = [NSBundle bundleForClass:[MMEAPIClient class]];
    NSString *certPath = [bundle pathForResource:name ofType:@"der" inDirectory:nil];
    NSData *certificateData = [NSData dataWithContentsOfFile:certPath];
    XCTAssertEqualObjects(certificateData, APIClientCertificate);
}

@end
