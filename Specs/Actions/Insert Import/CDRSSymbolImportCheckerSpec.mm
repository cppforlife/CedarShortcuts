#import <Cedar/Cedar.h>
#import "CDRSSymbolImportChecker.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(CDRSSymbolImportCheckerSpec)

describe(@"CDRSSymbolImportChecker", ^{
    __block CDRSSymbolImportChecker *subject;
    __block XC(DVTSourceTextStorage) textStorage;

    beforeEach(^{
        textStorage = nice_fake_for(@protocol(XCP(DVTSourceTextStorage)));

        subject = [[CDRSSymbolImportChecker alloc] initWithTextStorage:textStorage
                                                          formatString:@"#import %@.h"];
    });

    describe(@"-isSymbolImported:", ^{
        beforeEach(^{
            XC(DVTSourceLandmarkItem) landmarkItem = nice_fake_for(@protocol(XCP(DVTSourceLandmarkItem)));
            landmarkItem stub_method(@selector(name)).and_return(@"#import MySymbol.h");

            textStorage stub_method(@selector(importLandmarkItems))
                .and_return(@[landmarkItem]);

            textStorage stub_method(@selector(string))
                .and_return(@"@class OhDangWowReallyComeOnNow;");
        });

        it(@"should return TRUE when the import landmark items include the symbol", ^{
            [subject isSymbolImported:@"MySymbol"] should be_truthy;
        });

        it(@"should return TRUE when the source contains the symbol", ^{
            subject = [[CDRSSymbolImportChecker alloc] initWithTextStorage:textStorage
                                                              formatString:@"@class %@;"];
            [subject isSymbolImported:@"OhDangWowReallyComeOnNow"] should be_truthy;
        });

        it(@"should return FALSE otherwise", ^{
            [subject isSymbolImported:@"whoops"] should be_falsy;
        });
    });
});

SPEC_END
