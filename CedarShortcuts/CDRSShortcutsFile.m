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
            [self.mapping setObject:[declaration objectAtIndex:1] forKey:[declaration objectAtIndex:0]];
        }
    }
}

- (CDRSShortcut)commandForShortcut:(NSString *)key {
    NSString *command = [self.mapping objectForKey:key];

    if ([command isEqualToString:@"run-focused"])
        return CDRSShortcutRunFocused;
    if ([command isEqualToString:@"run-focused-last"])
        return CDRSShortcutRunFocusedLast;
    if ([command isEqualToString:@"run-focused-file"])
        return CDRSShortcutRunFocusedFile;
    return CDRSShortcutNotMatch;
}
@end
