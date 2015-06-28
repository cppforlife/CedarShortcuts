#import <Cocoa/Cocoa.h>

@class CDRSOpenAlternate;

@interface CDRSOpenAlternateMenu : NSObject
- (instancetype)initWithOpenAlternateAction:(CDRSOpenAlternate *)openAlternateAction NS_DESIGNATED_INITIALIZER;
- (void)attach;

- (void)alternateBetweenSpec:(id)sender;
- (void)openAlternateInAdjacentEditor:(id)sender;
@end

@interface CDRSOpenAlternateMenu (UnavailableInitializers)
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end
