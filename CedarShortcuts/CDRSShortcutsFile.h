#import <Foundation/Foundation.h>

typedef enum {
    CDRSShortcutNotMatch = 0,
    CDRSShortcutRunFocused,
    CDRSShortcutRunFocusedLast,
    CDRSShortcutRunFocusedFile
} CDRSShortcut;

@interface CDRSShortcutsFile : NSObject {
    NSString *_filePath;
    NSMutableDictionary *_mapping;
}

- (id)initWithFilePath:(NSString *)filePath;

- (CDRSShortcut)commandForShortcut:(NSString *)key;
@end
