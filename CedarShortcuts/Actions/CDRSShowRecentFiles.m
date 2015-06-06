#import "CDRSShowRecentFiles.h"
#import "CDRSFilePathNavigator.h"
#import "CDRSXcode.h"

@implementation CDRSShowRecentFiles

- (void)showMenu {
    XC(IDEEditorContext) editorContext =
        [[CDRSXcode currentEditor] editorContext];
    NSView *relatedItems = [(id)editorContext valueForKey:@"_relatedItemsPopUpButton"];

    [self._recentsMenu
        popUpMenuPositioningItem:nil
        atLocation:(NSPoint){100,100}
        inView:relatedItems];
}

- (NSMenu *)_recentsMenu {
    NSMenu *menu = [[[NSMenu alloc] init] autorelease];
    for (NSURL *fileURL in self._recentEditorDocumentURLs) {
        [menu addItem:[self _recentMenuItem:fileURL]];
    }
    return menu;
}

- (NSArray *)_recentEditorDocumentURLs {
    return CDRSXcode
        .currentWorkspaceController
        .activeWorkspaceTabController
        .workspaceDocument
        .recentEditorDocumentURLs;
}

#pragma mark -

- (NSMenuItem *)_recentMenuItem:(NSURL *)fileURL {
    NSMenuItem *item = [[[NSMenuItem alloc] init] autorelease];
    item.title = [fileURL.absoluteString lastPathComponent];
    item.target = self;
    item.action = @selector(_openRecentFile:);
    item.representedObject = fileURL;
    return item;
}

- (void)_openRecentFile:(NSMenuItem *)menuItem {
    NSURL *url = menuItem.representedObject;
    NSString *filePath = [url.absoluteString stringByReplacingOccurrencesOfString:@"file://localhost" withString:@""];

    XC(IDEEditorContext) editorContext =
        [[CDRSXcode currentEditor] editorContext];
    [CDRSFilePathNavigator
        openFilePath:filePath
        lineNumber:NSNotFound
        inEditorContext:editorContext];
}
@end
