#ifdef MME_ENABLE_DEBUG_LOGGING

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface MMEEventLogReportViewController : UIViewController

@property (nonatomic) WKWebView *webView;

- (void)displayHTMLFromRowsWithDataString:(NSString *)dataString;

@end

#endif
