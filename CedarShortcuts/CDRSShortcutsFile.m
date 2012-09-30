#import "CDRSShortcutsFile.h"

@interface CDRSShortcutsFile ()
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSMutableDictionary *mapping;
@end

@implementation CDRSShortcutsFile
@synthesize filePath = _filePath, mapping = _mapping;

- (id)initWithFilePath:(NSString *)filePath {
    if (self = [super init]) {
        self.filePath = filePath;
        NSLog(@"CedarShortcuts file - %@", self.filePath);

        self.mapping = [NSMutableDictionary dictionary];
        [self _load];
    }
    return self;
}

- (void)dealloc {
    [_filePath release];
    [_mapping release];
    [super dealloc];
}

#pragma mark - Key mapping

- (void)_load {
    NSError *error = nil;
    NSString *fileContents = [NSString stringWithContentsOfFile:self.filePath encoding:NSUTF8StringEncoding error:&error];

    if (error) {
        NSLog(@"Error reading: %@", error);
        return;
    }

    NSArray *lines = [fileContents componentsSeparatedByString:@"\n"];
    for (NSString *line in lines) {
        NSArray *declaration = [line componentsSeparatedByString:@": "];

        if (declaration.count == 2) {
            [self.mapping setObject:[declaration objectAtIndex:1]
                forKey:[self _normalizeKey:[declaration objectAtIndex:0]]];
        }
    }
}

- (NSString *)_normalizeKey:(NSString *)key {
    // U => shift+u
    if ([key isEqualToString:key.uppercaseString]) {
        key = [NSString stringWithFormat:@"shift+%@", key.lowercaseString];
    }

    // f1-f12 => 0xF704 - 0xF70f
    NSPredicate *isFKey = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"(.+\\+)?f[1-9]{1,2}"];
    if ([isFKey evaluateWithObject:key]) {
        NSRange lastPlus = [key rangeOfString:@"+" options:NSBackwardsSearch];
        NSUInteger fIndex = (lastPlus.location == NSNotFound ? 0 : lastPlus.location+1);

        int fNumber = [key substringFromIndex:fIndex+1].intValue;
        NSString *fKey = [NSString stringWithFormat:@"f%d", fNumber];
        NSString *fRealKey = [NSString stringWithFormat:@"%C", (unichar)(0xF703 + fNumber)];
        key = [key stringByReplacingOccurrencesOfString:fKey withString:fRealKey];
    }
    return key;
}

#pragma mark -

- (CDRSShortcut)commandForShortcut:(NSString *)key shiftKey:(BOOL)shiftKey {
    if (shiftKey) key = [NSString stringWithFormat:@"shift+%@", key];
    NSString *command = [self.mapping objectForKey:key.lowercaseString];

    if ([command isEqualToString:@"run-focused"])
        return CDRSShortcutRunFocused;
    if ([command isEqualToString:@"run-focused-last"])
        return CDRSShortcutRunFocusedLast;
    if ([command isEqualToString:@"run-focused-file"])
        return CDRSShortcutRunFocusedFile;
    return CDRSShortcutNotMatch;
}
@end
