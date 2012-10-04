#import <Cocoa/Cocoa.h>

@class CDRSRunFocusedMenu;

@interface CedarShortcuts : NSObject {
    CDRSRunFocusedMenu *_runFocusedMenu;
}

+ (void)pluginDidLoad:(NSBundle *)plugin;
@end
