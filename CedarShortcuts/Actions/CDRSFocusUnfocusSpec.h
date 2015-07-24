#import "CDRSXcodeInterfaces.h"

@interface CDRSFocusUnfocusSpec : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (id)initWithEditor:(XC(IDESourceCodeEditor))editor
     ignorablePrefix:(NSString *)ignorablePrefix
         prefixToAdd:(NSString *)prefixToAdd
       functionNames:(NSArray *)functionNames NS_DESIGNATED_INITIALIZER;

- (void)focusOrUnfocusSpec;
@end
