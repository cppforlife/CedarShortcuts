#import <Cocoa/Cocoa.h>

@class CDRSRunFocusedMenu, CDRSOpenAlternateMenu, CDRSEditMenu;

@interface CedarShortcuts : NSObject {
    CDRSRunFocusedMenu *_runFocusedMenu;
    CDRSOpenAlternateMenu *_openAlternateMenu;
    CDRSEditMenu *_editMenu;
}

+ (void)pluginDidLoad:(NSBundle *)plugin;
@end
