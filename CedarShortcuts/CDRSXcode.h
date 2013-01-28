#import <Cocoa/Cocoa.h>

@interface CDRSXcode
@end

@interface CDRSXcode (Menu)
+ (id)menuWithTitle:(NSString *)title;
@end

@interface CDRSXcode (Workspace)
+ (id)currentWorkspace;
+ (id)currentWorkspaceController;
+ (id)currentSourceCodeEditor;
@end

@interface CDRSXcode (Alert)
+ (void)flashAlertMessage:(NSString *)message;
@end

#pragma mark - Run contexts and destinations

#define XC(type) id<CDRSXcode_##type>

@protocol CDRSXcode_RunContext <NSObject>
- (BOOL)isTestable;
- (NSString *)name;
@end

@protocol CDRSXcode_RunDestination <NSObject>
- (NSString *)fullDisplayName;
@end

@protocol CDRSXcode_RunContextManager <NSObject>
- (XC(RunContext))activeRunContext;
- (NSArray *)runContexts;

- (XC(RunDestination))activeRunDestination;
- (NSArray *)availableRunDestinations;

- (void)setActiveRunContext:(XC(RunContext))context
    andRunDestination:(XC(RunDestination))destination;
@end

@protocol CDRSXcode_Workspace <NSObject>
- (XC(RunContextManager))runContextManager;
@end
