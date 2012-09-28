#import "IDELaunchSession_Customize.h"
#import "NSObject+ChainSelector.h"

#define INIT_METHOD(prefix) \
    prefix ## _initWithExecutionEnvironment:(id)executionEnvironment  \
                           launchParameters:(id)launchParameters      \
                        runnableDisplayName:(id)runnableDisplayName   \
                               runnableType:(id)runnableType          \
                             runDestination:(id)runDestination

@interface IDELaunchSession_Customize (ChainSelector)
- (id)INIT_METHOD(withoutCustomizeBlock);
@end

@implementation IDELaunchSession_Customize
static CustomizeBlock __customizeBlock = nil;

+ (void)setUp {
    static BOOL done = NO;
    if (!done) {
        done = YES;
        SEL selector = @selector(initWithExecutionEnvironment:launchParameters:runnableDisplayName:runnableType:runDestination:);
        [self chainSelector:selector inClass:NSClassFromString(@"IDELaunchSession") prefix:@"customizeBlock"];
    }
}

+ (void)customizeNextLaunchSession:(CustomizeBlock)block {
    [__customizeBlock release];
    __customizeBlock = [block retain];
}

- (id)INIT_METHOD(withCustomizeBlock) {
    id launchSession = [self INIT_METHOD(withoutCustomizeBlock)];
    if (__customizeBlock) {
        __customizeBlock(launchSession);
        [__customizeBlock release];
        __customizeBlock = nil;
    }
    return launchSession;
}
@end
