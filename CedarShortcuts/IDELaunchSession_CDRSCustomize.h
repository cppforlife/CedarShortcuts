#import "CDRSXcodeInterfaces.h"

typedef void (^CDRSCustomizeBlock)(XC(IDELaunchSession));

@interface IDELaunchSession_CDRSCustomize : NSObject
+ (void)customizeNextLaunchSession:(CDRSCustomizeBlock)block;
@end
