#import "IDELaunchSession_CDRSCustomize.h"
#import "NSObject+CDRSChainSelector.h"

#define INIT_METHOD(prefix) \
    prefix ## _initWithExecutionEnvironment:(id)executionEnvironment  \
                           launchParameters:(id)launchParameters      \
                        runnableDisplayName:(id)runnableDisplayName   \
                               runnableType:(id)runnableType          \
                             runDestination:(id)runDestination

@interface IDELaunchSession_CDRSCustomize (CDRSChainSelector)
- (id)INIT_METHOD(withoutCDRSCustomizeBlock);
@end

@implementation IDELaunchSession_CDRSCustomize
static CDRSCustomizeBlock __customizeBlock = nil;

+ (void)cdrs_setUp {
    static BOOL done = NO;
    if (!done) {
        done = YES;
        SEL selector = @selector(initWithExecutionEnvironment:launchParameters:runnableDisplayName:runnableType:runDestination:);
        [self cdrs_chainSelector:selector inClass:NSClassFromString(@"IDELaunchSession") prefix:@"CDRSCustomizeBlock"];
    }
}

+ (void)cdrs_customizeNextLaunchSession:(CDRSCustomizeBlock)block {
    [__customizeBlock release];
    __customizeBlock = [block copy];
}

- (id)INIT_METHOD(withCDRSCustomizeBlock) {
    id launchSession = [self INIT_METHOD(withoutCDRSCustomizeBlock)];
    if (__customizeBlock) {
        __customizeBlock(launchSession);
        [__customizeBlock release];
        __customizeBlock = nil;
    }
    return launchSession;
}
@end
