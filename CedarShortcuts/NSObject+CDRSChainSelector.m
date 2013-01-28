#import "NSObject+CDRSChainSelector.h"
#import <objc/runtime.h>

#define F(f, ...) [NSString stringWithFormat:f, ##__VA_ARGS__]

@implementation NSObject (CDRSChainSelector)

// Based on http://blog.walkingsmarts.com/objective-c-method-swizzling-rails-style-a-k-a-alias-method-chain/
+ (void)cdrs_chainSelector:(SEL)selector inClass:(Class)klass prefix:(NSString *)prefix {
    NSString *selectorStr = NSStringFromSelector(selector);
    NSString *prefixCapitalized = [prefix
        stringByReplacingCharactersInRange:NSMakeRange(0, 1)
        withString:[[prefix substringToIndex:1] capitalizedString]];

    Method method = class_getInstanceMethod(klass, selector);

    // alias without* -> original
    SEL withoutSel = sel_registerName([F(@"without%@_%@", prefixCapitalized, selectorStr) UTF8String]);
    class_addMethod(klass, withoutSel, method_getImplementation(method), method_getTypeEncoding(method));

    // alias original -> with*
    SEL withSel = sel_registerName([F(@"with%@_%@", prefixCapitalized, selectorStr) UTF8String]);
    method_setImplementation(method, [self instanceMethodForSelector:withSel]);
}
@end
