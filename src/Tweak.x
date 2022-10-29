#import "../headers/HeadersTweak.h"

%hook NCNotificationShortLookViewController
%property (nonatomic,retain) UIView *borderView;

-(void)viewDidLoad {
    %orig;

    NCNotificationShortLookView *view = (NCNotificationShortLookView *)self.viewForPreview;

    UIView *borderView = [UIView new];
    [borderView.layer insertSublayer:[CAGradientLayer layer] atIndex:0];
    [view.backgroundMaterialView.superview insertSubview:borderView atIndex:2];

    self.borderView = borderView;
    self.borderView.clipsToBounds = YES;
}

-(void)viewDidLayoutSubviews {
    %orig;

    // NSLog(@"Notification: %@", self.notificationRequest.sectionIdentifier);

    // Initialize content variables
    NCNotificationShortLookView *view                       = (NCNotificationShortLookView *)self.viewForPreview;
    MTMaterialView *materialView                            = view.backgroundMaterialView;
    NCNotificationViewControllerView *controllerView        = [self valueForKey:@"contentSizeManagingView"];
    UIView *stackDimmingView                                = [controllerView valueForKey:@"stackDimmingView"];
    CAGradientLayer *singleBorder                           = self.borderView.layer.sublayers[0];
    NCNotificationSeamlessContentView *contentView          = [view valueForKey:@"notificationContentView"];
    UILabel *title                                          = [contentView valueForKey:@"primaryTextLabel"];
    // UILabel *message                                     = [contentView valueForKey:@"secondaryTextElement"];
    // UILabel *dateLabel                                   = [contentView valueForKey:@"dateLabel"];
    NCBadgedIconView *badgedIconView                        = [contentView valueForKey:@"badgedIconView"];
    UIView *appIcon                                         = badgedIconView.iconView;

    NSArray *gradientColors = @[(id)[UIColor colorWithRed: 0.25 green: 0.79 blue: 1.00 alpha: 1.00].CGColor, (id)[UIColor colorWithRed: 0.91 green: 0.11 blue: 1.00 alpha: 1.00].CGColor];
    UIColor *gradientColor = [UIColor colorFromGradient:gradientColors withDirection:DirectionRight inFrame:materialView.frame];
    
    // Corner radius
    BOOL useCircleRadius = NO;
    CGFloat cornerRadius = useCircleRadius ? MIN(60, materialView.frame.size.height / 2) : 19;
    view.layer.cornerRadius = cornerRadius;
    materialView.layer.cornerRadius = cornerRadius;
    materialView.superview.layer.cornerRadius = cornerRadius;
    stackDimmingView.layer.cornerRadius = cornerRadius;
    self.borderView.layer.cornerRadius = cornerRadius;

    // Background
    // materialView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:1.0];

    // Single border
    self.borderView.frame = materialView.frame;
    singleBorder.frame = CGRectMake(0, materialView.frame.size.height - 3, materialView.frame.size.width, 3);
    // singleBorder.backgroundColor = gradientColor.CGColor;

    // Full border
    materialView.layer.borderWidth = 2;
    materialView.layer.borderColor = gradientColor.CGColor;

    // Shadow
	materialView.layer.shadowOpacity = 0.75;
	materialView.layer.shadowOffset = CGSizeZero;
	materialView.layer.shadowRadius = 5;
	materialView.layer.shadowColor = UIColor.whiteColor.CGColor;

    // Title
    title.textColor = gradientColor;

    // Message
    // message.textColor = customColor;
    // message.textAlignment = NSTextAlignmentCenter;

    // Date
    // dateLabel.textColor = UIColor.redColor;
    // dateLabel.layer.filters = nil;

    // Icon
    appIcon.layer.cornerRadius = 19;
    appIcon.clipsToBounds = YES;
}
%end

%hook NCNotificationStructuredListViewController
-(void)viewDidLoad {
    %orig;
    // self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
}
%end