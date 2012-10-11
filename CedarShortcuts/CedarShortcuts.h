#import <Cocoa/Cocoa.h>

@class CDRSRunFocusedMenu, CDRSEditMenu, CDRSOpenAlternateMenu;

@interface CedarShortcuts : NSObject {
    CDRSRunFocusedMenu *_runFocusedMenu;
    CDRSEditMenu *_editMenu;
    CDRSOpenAlternateMenu *_openAlternateMenu;
}

+ (void)pluginDidLoad:(NSBundle *)plugin;
@end
