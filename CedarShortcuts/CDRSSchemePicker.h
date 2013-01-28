#import "CDRSXcodeInterfaces.h"

@interface CDRSSchemePicker : NSObject {
    XC(Workspace) _workspace;
    XC(RunContext) _foundScheme;
    XC(RunDestination) _foundDestination;
}

+ (CDRSSchemePicker *)forWorkspace:(XC(Workspace))workspace;

- (id)initWithWorkspace:(XC(Workspace))workspace;

- (void)findSchemeForTests;

- (void)makeFoundSchemeAndDestinationActive;
- (void)testActiveSchemeAndDestination;
@end
