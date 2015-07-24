#import "CDRSXcodeInterfaces.h"

@interface CDRSSchemePicker : NSObject

+ (CDRSSchemePicker *)forWorkspace:(XC(Workspace))workspace;

- (id)initWithWorkspace:(XC(Workspace))workspace;

- (void)findSchemeForTests;

- (void)makeFoundSchemeAndDestinationActive;
- (void)testActiveSchemeAndDestination;
@end
