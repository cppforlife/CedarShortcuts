#import <Cocoa/Cocoa.h>

@class CDRSRunFocusedMenu, CDRSEditMenu;

@interface CedarShortcuts : NSObject {
    CDRSRunFocusedMenu *_runFocusedMenu;
    CDRSEditMenu *_editMenu;
}

+ (void)pluginDidLoad:(NSBundle *)plugin;
@end
