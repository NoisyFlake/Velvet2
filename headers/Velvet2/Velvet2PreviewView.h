@interface Velvet2PreviewView : UIView
@property (nonatomic,copy) NSString * identifier;
@property (nonatomic,retain) UIView *notificationView;
@property (nonatomic,retain) MTMaterialView *materialView;
@property (nonatomic,retain) UIView *velvetView;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *messageLabel;
@property (nonatomic,retain) UILabel *dateLabel;
@property (nonatomic,retain) UIImageView *appIcon;
@property (nonatomic,copy) NSString * currentIconIdentifier;
-(instancetype)initWithFrame:(CGRect)frame notificationWidth:(CGFloat)width identifier:(NSString *)identifier;
-(void)updatePreview;
-(void)updateAppIconWithIdentifier:(NSString*)identifier;
-(void)handleTouch:(UITapGestureRecognizer *)recognizer;
@end