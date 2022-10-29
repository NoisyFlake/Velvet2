#import <Preferences/PSListController.h>

@interface Velvet2SettingsController : PSListController
@property (nonatomic,copy) NSString * identifier;
@property (nonatomic,retain) UIView *notificationView;
@property (nonatomic,retain) MTMaterialView *materialView;
@property (nonatomic,retain) UIView *velvetView;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *messageLabel;
@property (nonatomic,retain) UILabel *dateLabel;
@property (nonatomic,retain) UIImageView *appIcon;
-(void)updatePreview;
-(void)updateAppIconWithIdentifier:(NSString*)identifier;
-(void)handleHeaderTouch:(UITapGestureRecognizer *)recognizer;
@end