#import <Cedar/Cedar.h>
#import "CDRSFileExtensionValidator.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(CDRSFileExtensionValidatorSpec)

describe(@"CDRSFileExtensionValidator", ^{
    __block CDRSFileExtensionValidator *subject;

    beforeEach(^{
        subject = [[CDRSFileExtensionValidator alloc] init];
    });

    it(@"should accept objective c files", ^{
        [subject isValidSourceFileExtension:@"m"] should be_truthy;
    });

    it(@"should accept swift files", ^{
        [subject isValidSourceFileExtension:@"swift"] should be_truthy;
    });

    it(@"should accept objective c++ files", ^{
        [subject isValidSourceFileExtension:@"mm"] should be_truthy;
    });

    it(@"should not accept other file extensions", ^{
        [subject isValidSourceFileExtension:@"garbage"] should be_falsy;
    });
});

SPEC_END
