#import <Cocoa/Cocoa.h>

@interface CDRSXcode
@end

@interface CDRSXcode (Menu)
+ (NSMenu *)menuWithTitle:(NSString *)title;
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

#define XCP(type) CDRSXcode_##type
#define XC(type) id<CDRSXcode_##type>

@protocol XCP(RunContext)
- (BOOL)isTestable;
- (NSString *)name;
@end

@protocol XCP(RunDestination)
- (NSString *)fullDisplayName;
@end

@protocol XCP(RunContextManager)
- (XC(RunContext))activeRunContext;
- (NSArray *)runContexts;

- (XC(RunDestination))activeRunDestination;
- (NSArray *)availableRunDestinations;

- (void)setActiveRunContext:(XC(RunContext))context
    andRunDestination:(XC(RunDestination))destination;
@end

@protocol XCP(Workspace)
- (XC(RunContextManager))runContextManager;
@end

#pragma mark - Session launching

@protocol XCP(IDELaunchParametersSnapshot)
// though env variables are exposed as NSDictionary* in Xcode headers
- (NSMutableDictionary *)environmentVariables;
- (NSMutableDictionary *)testingEnvironmentVariables;
- (void)setTestingEnvironmentVariables:(NSMutableDictionary *)variables;
@end

@protocol XCP(IDELaunchSession)
- (XC(IDELaunchParametersSnapshot))launchParameters;
@end
