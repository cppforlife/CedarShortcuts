#import <Cocoa/Cocoa.h>

@class CDRSRunFocusedMenu, CDRSOpenAlternateMenu, CDRSEditMenu, CDRSViewMenu;

@interface CedarShortcuts : NSObject {
    CDRSRunFocusedMenu *_runFocusedMenu;
    CDRSOpenAlternateMenu *_openAlternateMenu;
    CDRSEditMenu *_editMenu;
    CDRSViewMenu *_viewMenu;
}

+ (void)pluginDidLoad:(NSBundle *)plugin;
@end
