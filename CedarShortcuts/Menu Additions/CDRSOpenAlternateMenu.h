#import <Cocoa/Cocoa.h>

@class CDRSOpenAlternate;

@interface CDRSOpenAlternateMenu : NSObject
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithOpenAlternateAction:(CDRSOpenAlternate *)openAlternateAction NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (void)attach;

- (void)alternateBetweenSpec:(id)sender;
- (void)openAlternateInAdjacentEditor:(id)sender;
@end
