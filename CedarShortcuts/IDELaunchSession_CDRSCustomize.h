#import <Foundation/Foundation.h>

typedef void (^CDRSCustomizeBlock)(id);

@interface IDELaunchSession_CDRSCustomize : NSObject
+ (void)cdrs_setUp;
+ (void)cdrs_customizeNextLaunchSession:(CDRSCustomizeBlock)block;
@end

@interface IDELaunchSession_CDRSCustomize (CDRSClassDump)
// IDELaunchSession
- (id)launchParameters;

// IDELaunchParametersSnapshot
// actually a non-mutable dictionary!
- (NSMutableDictionary *)environmentVariables;
@end
