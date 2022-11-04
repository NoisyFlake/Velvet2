#import <Preferences/PSListController.h>
#import "Velvet2PreviewView.h"

@interface Velvet2PreviewController : PSListController

@property (nonatomic,copy) NSString * identifier;
@property (nonatomic,copy) NSString * identifierName;
@property (nonatomic,retain) Velvet2PreviewView *preview;

- (NSMutableArray*)visibleSpecifiersFromPlist:(NSString*)plist;

@end