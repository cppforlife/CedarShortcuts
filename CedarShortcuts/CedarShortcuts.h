#import <Cocoa/Cocoa.h>

@class CDRSRunFocusedMenu, CDRSOpenAlternateMenu;

@interface CedarShortcuts : NSObject {
    CDRSRunFocusedMenu *_runFocusedMenu;
    CDRSOpenAlternateMenu *_openAlternateMenu;
}

+ (void)pluginDidLoad:(NSBundle *)plugin;
@end
