#import <Cocoa/Cocoa.h>

@interface CDRSXcode
@end

@interface CDRSXcode (Workspace)
+ (id)currentWorkspaceController;
+ (id)currentSourceCodeEditor;
@end

@interface CDRSXcode (Alert)
+ (void)flashAlertMessage:(NSString *)message;
@end
