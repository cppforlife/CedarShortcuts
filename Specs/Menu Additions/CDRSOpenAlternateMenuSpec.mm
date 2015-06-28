#import <Cedar/Cedar.h>
#import "CDRSOpenAlternateMenu.h"
#import "CDRSOpenAlternate.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(CDRSOpenAlternateMenuSpec)

describe(@"CDRSOpenAlternateMenu", ^{
    __block CDRSOpenAlternateMenu *subject;
    __block CDRSOpenAlternate *action;

    beforeEach(^{
        action = fake_for([CDRSOpenAlternate class]);
        subject = [[CDRSOpenAlternateMenu alloc] initWithOpenAlternateAction:action];
    });

    describe(@"recovering from errors", ^{
        context(@"when opening the alternate file in the adjacent editor would raise an exception", ^{
            beforeEach(^{
                action stub_method(@selector(openAlternateInAdjacentEditor)).and_raise_exception();
            });

            it(@"should not crash xcode", ^{
                ^{ [subject openAlternateInAdjacentEditor:nil]; } should_not raise_exception;
            });
        });

        context(@"when opening the alternate file in the same editor would raise an exception", ^{
            beforeEach(^{
                action stub_method(@selector(alternateBetweenSpec)).and_raise_exception();
            });

            it(@"should not crash xcode", ^{
                ^{ [subject alternateBetweenSpec:nil]; } should_not raise_exception;
            });
        });
    });
});

SPEC_END
