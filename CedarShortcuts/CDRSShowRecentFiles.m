#import "CDRSShowRecentFiles.h"
#import "CDRSFilePathNavigator.h"
#import "CDRSXcode.h"

@interface CDRSShowRecentFiles (CDRSClassDump)
- (id)activeWorkspaceTabController;
- (id)workspaceDocument;
- (id)editorContext;
- (id)recentEditorDocumentURLs;
@end

@implementation CDRSShowRecentFiles

- (void)showMenu {
    id editorContext = [[CDRSXcode currentSourceCodeEditor] editorContext];
    id relatedItems = [editorContext valueForKey:@"_relatedItemsPopUpButton"];

    [self._recentsMenu
        popUpMenuPositioningItem:nil
        atLocation:(NSPoint){100,100}
        inView:relatedItems];
}

- (NSMenu *)_recentsMenu {
    NSMenu *menu = [[[NSMenu alloc] init] autorelease];
    NSArray *recentURLs = [self._workspaceDocument recentEditorDocumentURLs];

    for (NSURL *fileURL in recentURLs) {
        [menu addItem:[self _recentMenuItem:fileURL]];
    }
    return menu;
}

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

    id editorContext = [[CDRSXcode currentSourceCodeEditor] editorContext];

    [CDRSFilePathNavigator
        openFilePath:filePath
        lineNumber:NSNotFound
        inEditorContext:editorContext];
}

- (id)_workspaceDocument {
    id workspaceController = [CDRSXcode currentWorkspaceController];
    return [[workspaceController activeWorkspaceTabController] workspaceDocument];
}
@end
