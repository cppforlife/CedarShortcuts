#import <Foundation/Foundation.h>

@interface NSObject (ChainSelector)

// method -> onlyMethod
// prefixWithMethod -> method
+ (void)chainSelector:(SEL)srcSelector inClass:(Class)klass prefix:(NSString *)prefix;
@end