#import <Preferences/PSListController.h>

@interface Velvet2SettingsController : PSListController
@property (nonatomic,copy) NSString * identifier;
@property (nonatomic,retain) MTMaterialView *materialView;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *messageLabel;
@property (nonatomic,retain) UILabel *dateLabel;
@end