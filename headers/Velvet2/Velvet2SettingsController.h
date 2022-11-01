#import <Preferences/PSListController.h>

@interface Velvet2SettingsController : PSListController
@property (nonatomic,copy) NSString * identifier;
@property (nonatomic,retain) Velvet2PreviewView *preview;
@end