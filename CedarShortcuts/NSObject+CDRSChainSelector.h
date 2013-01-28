#import <Foundation/Foundation.h>

@interface NSObject (CDRSChainSelector)

// method -> onlyMethod
// prefixWithMethod -> method
+ (void)cdrs_chainSelector:(SEL)srcSelector inClass:(Class)klass prefix:(NSString *)prefix;
@end
