#import <Foundation/Foundation.h>

typedef void (^CDRSCustomizeBlock)(id);

@interface IDELaunchSession_CDRSCustomize : NSObject
+ (void)customizeNextLaunchSession:(CDRSCustomizeBlock)block;
@end

@interface IDELaunchSession_CDRSCustomize (CDRSClassDump)
// IDELaunchSession
- (id)launchParameters;

// IDELaunchParametersSnapshot
// actually a non-mutable dictionary!
- (NSMutableDictionary *)environmentVariables;
- (id)testingEnvironmentVariables;
- (void)setTestingEnvironmentVariables:(NSDictionary *)vars;
@end
