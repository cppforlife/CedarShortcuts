#import <Foundation/Foundation.h>

@class CDRSFileExtensionValidator;

@interface CDRSOpenAlternate : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFileExtensionValidator:(CDRSFileExtensionValidator *)fileExtensionValidator NS_DESIGNATED_INITIALIZER;

- (void)alternateBetweenSpec;
- (void)openAlternateInAdjacentEditor;
@end
