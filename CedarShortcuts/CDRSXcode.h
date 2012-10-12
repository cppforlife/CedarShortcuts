#import <Cocoa/Cocoa.h>

@interface CDRSXcode
@end

@interface CDRSXcode (Menu)
+ (id)menuWithTitle:(NSString *)title;
@end

@interface CDRSXcode (Workspace)
+ (id)currentWorkspaceController;
+ (id)currentSourceCodeEditor;
@end

@interface CDRSXcode (Alert)
+ (void)flashAlertMessage:(NSString *)message;
@end
