#import <Cedar/Cedar.h>
#import "CDRSSymbolImportValidator.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(CDRSSymbolImportValidatorSpec)

describe(@"CDRSSymbolImportValidator", ^{
    __block CDRSSymbolImportValidator *subject;

    beforeEach(^{
        subject = [[CDRSSymbolImportValidator alloc] init];
    });

    describe(@"-isValidSymbol:", ^{
        context(@"invalid symbols", ^{
            it(@"should not treat nil as a valid symbol", ^{
                [subject isValidSymbol:nil] should be_falsy;
            });

            it(@"should not treat @protocol as a valid symbol", ^{
                [subject isValidSymbol:@"@protocol"] should be_falsy;
            });
        });

        context(@"valid symbols", ^{
            it(@"should treat a class name as a valid symbol", ^{
                [subject isValidSymbol:@"MySpecialClassName"] should be_truthy;
            });
        });
    });
});

SPEC_END
