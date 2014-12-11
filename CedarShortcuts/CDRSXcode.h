#import <Cocoa/Cocoa.h>
#import "CDRSXcodeInterfaces.h"

@interface CDRSXcode : NSObject 
+ (NSMenu *)menuWithTitle:(NSString *)title;
@end

@interface CDRSXcode (Workspace)
+ (XC(IDEWorkspaceWindowController))currentWorkspaceController;
+ (XC(Workspace))currentWorkspace;
+ (id)currentEditor;
+ (NSURL *)currentSourceCodeDocumentFileURL;
@end
