#import <Foundation/Foundation.h>

@interface CDRSSchemePicker : NSObject {
    id _workspace;
    id _foundScheme;
    id _foundDestination;
}

- (id)initWithWorkspace:(id)workspace;

- (void)findSchemeForTests;

- (void)makeFoundSchemeAndDestinationActive;
- (void)testActiveSchemeAndDestination;
@end
