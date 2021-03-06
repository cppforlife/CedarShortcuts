#import <Foundation/Foundation.h>

#pragma mark - Run contexts and destinations

#define XCP(type) CDRSXcode_##type
#define XC(type) id<CDRSXcode_##type>

@protocol XCP(DVTFilePath)
- (NSString *)pathString;
@end

@protocol XCP(RunContext)
- (BOOL)isTestable;
- (NSString *)name;
@end

@protocol XCP(RunDestination)
- (NSString *)fullDisplayName;
@end

@protocol XCP(RunContextManager)
- (XC(RunContext))activeRunContext;
- (NSArray *)runContexts;

- (XC(RunDestination))activeRunDestination;
- (NSArray *)availableRunDestinations;

- (void)setActiveRunContext:(XC(RunContext))context
    andRunDestination:(XC(RunDestination))destination;
@end

@protocol XCP(Workspace)
- (XC(RunContextManager))runContextManager;
- (XC(DVTFilePath))representingFilePath;
@end

@protocol XCP(IDEWorkspaceDocument)
- (NSArray *)recentEditorDocumentURLs;
@end

@protocol XCP(IDEWorkspaceTabController)
- (XC(IDEWorkspaceDocument))workspaceDocument;
@end

@protocol XCP(IDEWorkspaceWindowController)
- (XC(IDEWorkspaceTabController))activeWorkspaceTabController;
@end


#pragma mark - Session launching

@protocol XCP(IDELaunchParametersSnapshot)
// though env variables are exposed as NSDictionary* in Xcode headers
- (NSMutableDictionary *)environmentVariables;
- (NSMutableDictionary *)testingEnvironmentVariables;
@end

@protocol XCP(IDELaunchSession)
@property(retain) XC(IDELaunchParametersSnapshot) launchParameters;
@end


#pragma mark - Editors

@protocol XCP(DVTSourceExpression)
- (NSString *)symbolString;
- (NSRange)expressionRange;
@end

@protocol XCP(DVTSourceLandmarkItem)
- (NSRange)range;
- (NSString *)name;
@end

@protocol XCP(DVTSourceTextStorage)
- (NSString *)string;
- (NSArray *)importLandmarkItems;

- (NSUInteger)nextExpressionFromIndex:(unsigned long long)index
                              forward:(BOOL)forward;

- (void)replaceCharactersInRange:(NSRange)range
                      withString:(NSString *)string
                 withUndoManager:(id)undoManager;
@end

@protocol XCP(DVTTextDocumentLocation)
- (NSRange)characterRange;
@end

@protocol XCP(IDEEditorContext)
@end

@protocol XCP(IDESourceCodeDocument)
- (NSURL *)fileURL;
- (XC(DVTSourceTextStorage))textStorage;
- (id)undoManager;
@end

@protocol XCP(IDESourceCodeEditor)
- (XC(IDEEditorContext))editorContext;
- (XC(IDESourceCodeDocument))sourceCodeDocument;
- (XC(DVTSourceExpression))_expressionAtCharacterIndex:(NSRange)range;
- (NSArray *)currentSelectedDocumentLocations;
- (long long)_currentOneBasedLineNumber; // this selector was renamed at some unknown point
- (long long)_currentOneBasedLineNubmer; // this typo definitely existed prior to xcode 6
@end
