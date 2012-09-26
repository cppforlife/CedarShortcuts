#import <Cocoa/Cocoa.h>

@class CDRSShortcutsFile;

@interface CedarShortcuts : NSObject {
    id _keyPressMonitor;
    CDRSShortcutsFile *_shortcutsFile;
}

+ (void)pluginDidLoad:(NSBundle *)plugin;

- (CDRSShortcutsFile *)shortcutsFile;
@end
