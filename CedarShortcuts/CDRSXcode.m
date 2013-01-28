#import "CDRSXcode.h"

@implementation CDRSXcode
@end

@implementation CDRSXcode (Menu)
+ (id)menuWithTitle:(NSString *)title {
    return [[[NSApp mainMenu] itemWithTitle:title] submenu];
}
@end

@interface CDRSXcode (WorkspaceClassDump)
- (id)editor;
- (id)editorArea;
- (id)lastActiveEditorContext;
@end

@implementation CDRSXcode (Workspace)

+ (id)currentWorkspaceController {
    id workspaceController = [[NSApp keyWindow] windowController];
    if ([workspaceController isKindOfClass:NSClassFromString(@"IDEWorkspaceWindowController")]) {
        return workspaceController;
    }
    return nil;
}

+ (id)currentSourceCodeEditor {
    id editorArea = [self.currentWorkspaceController editorArea];  // IDEEditorArea
    id editorContext = [editorArea lastActiveEditorContext];       // IDEEditorContext
    return [editorContext editor];                                 // IDESourceCodeEditor
}
@end


@interface CDRSXcode (AlertClassDump)
- (id)initWithIcon:(id)icon
           message:(id)message
      parentWindow:(id)window
          duration:(double)duration;
@end

@implementation CDRSXcode (Alert)

+ (void)flashAlertMessage:(NSString *)message {
    id alertPanel =
        [[NSClassFromString(@"DVTBezelAlertPanel") alloc]
            initWithIcon:nil message:message parentWindow:nil duration:2.0];
    [alertPanel orderFront:nil];
    [alertPanel release];
}
@end
