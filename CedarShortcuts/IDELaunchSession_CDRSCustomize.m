#import "IDELaunchSession_CDRSCustomize.h"
#import "NSObject+CDRSChainSelector.h"

#define INIT_METHOD(prefix) \
    prefix ## initWithExecutionEnvironment:(id)executionEnvironment  \
                          launchParameters:(id)launchParameters      \
                       runnableDisplayName:(id)runnableDisplayName   \
                              runnableType:(id)runnableType          \
                            runDestination:(id)runDestination

@interface IDELaunchSession_CDRSCustomize (ClassDump)
- (id)INIT_METHOD();
@end

@interface IDELaunchSession_CDRSCustomize (CDRSChainSelector)
- (id)INIT_METHOD(withoutCDRSCustomizeBlock_);
@end

@implementation IDELaunchSession_CDRSCustomize
static CDRSCustomizeBlock __customizeBlock = nil;

+ (void)_setUp {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self cdrs_chainSelector:@selector(
            initWithExecutionEnvironment:
            launchParameters:
            runnableDisplayName:
            runnableType:
            runDestination:
        ) inClass:NSClassFromString(@"IDELaunchSession") prefix:@"CDRSCustomizeBlock"];
    });
}

+ (void)customizeNextLaunchSession:(CDRSCustomizeBlock)block {
    [self _setUp];
    __customizeBlock = [block copy];
}

- (id)INIT_METHOD(withCDRSCustomizeBlock_) {
    id launchSession = [self INIT_METHOD(withoutCDRSCustomizeBlock_)];
    if (__customizeBlock) {
        __customizeBlock(launchSession);
        __customizeBlock = nil;
    }
    return launchSession;
}
@end
