#import <Foundation/Foundation.h>
#import "CDRSXcode.h"

@interface CDRSSchemePicker : NSObject {
    XC(Workspace) _workspace;
    XC(RunContext) _foundScheme;
    XC(RunDestination) _foundDestination;
}

- (id)initWithWorkspace:(XC(Workspace))workspace;

- (void)findSchemeForTests;

- (void)makeFoundSchemeAndDestinationActive;
- (void)testActiveSchemeAndDestination;
@end
