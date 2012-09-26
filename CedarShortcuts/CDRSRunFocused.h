#import <Cocoa/Cocoa.h>

@interface CDRSRunFocused : NSObject {
    id _workspaceController;
}

- (id)initWithWorkspaceController:(id)workspaceController;
- (BOOL)runFocused;
- (BOOL)runFocusedLast;
- (BOOL)runFocusedFile;
@end
