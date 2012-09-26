#import <Foundation/Foundation.h>

typedef void (^CustomizeBlock)(id);

@interface IDELaunchSession_Customize : NSObject
+ (void)setUp;
+ (void)customizeNextLaunchSession:(CustomizeBlock)block;
@end

@interface IDELaunchSession_Customize (ClassDump)
// IDELaunchSession
- (id)launchParameters;

// IDELaunchParametersSnapshot
// actually a non-mutable dictionary!
- (NSMutableDictionary *)environmentVariables;
@end
