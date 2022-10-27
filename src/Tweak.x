#import "Headers/Tweak.h"

%hook NCNotificationShortLookViewController
%property (nonatomic,retain) UIView *borderView;

-(void)viewDidLoad {
    %orig;

    NCNotificationShortLookView *view = (NCNotificationShortLookView *)self.viewForPreview;

    UIView *borderView = [UIView new];
    borderView.clipsToBounds = YES;

    CAGradientLayer *borderGradient = [CAGradientLayer layer];
    [borderView.layer insertSublayer:borderGradient atIndex:0];

    [view.backgroundMaterialView.superview insertSubview:borderView atIndex:2];

    self.borderView = borderView;
}

-(void)viewDidLayoutSubviews {
    %orig;

    // NSLog(@"Notification: %@", self.notificationRequest.sectionIdentifier);

    // Initialize content variables
    NCNotificationShortLookView *view = (NCNotificationShortLookView *)self.viewForPreview;
    MTMaterialView *materialView = view.backgroundMaterialView;
    NCNotificationViewControllerView *controllerView = [self valueForKey:@"contentSizeManagingView"];
    UIView *stackDimmingView = [controllerView valueForKey:@"stackDimmingView"];
    CAGradientLayer *borderGradient = self.borderView.layer.sublayers[0];
    NCNotificationSeamlessContentView *contentView = [view valueForKey:@"notificationContentView"];
    UILabel *title = [contentView valueForKey:@"primaryTextLabel"];
    NCBadgedIconView *badgedIconView = [contentView valueForKey:@"badgedIconView"];
    UIView *appIcon = badgedIconView.iconView;
    // UILabel *message = [contentView valueForKey:@"secondaryTextElement"];
    // UILabel *dateLabel = [contentView valueForKey:@"dateLabel"];

    // Corner Radius, maximum 22 OR half height for circle.
    // The reason for maximum 22 is https://stackoverflow.com/questions/24936003/
    BOOL useCircleRadius = NO;
    CGFloat cornerRadius = useCircleRadius ? MIN(60, materialView.frame.size.height / 2) : 19;

    view.layer.cornerRadius = cornerRadius;
    materialView.layer.cornerRadius = cornerRadius;
    materialView.superview.layer.cornerRadius = cornerRadius;
    stackDimmingView.layer.cornerRadius = cornerRadius;
    self.borderView.layer.cornerRadius = cornerRadius;

    // Background
    // materialView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:1.0];

    // Gradient border
    self.borderView.frame = materialView.frame;
    borderGradient.frame = self.borderView.frame;
    borderGradient.startPoint = CGPointMake(0, 0);
    borderGradient.endPoint = CGPointMake(1, 0);
    borderGradient.colors = @[(id)[UIColor colorWithRed: 0.25 green: 0.79 blue: 1.00 alpha: 1.00].CGColor, (id)[UIColor colorWithRed: 0.91 green: 0.11 blue: 1.00 alpha: 1.00].CGColor];

    if (YES) {
        // Full border
        CAShapeLayer *borderShape = [CAShapeLayer new];
        borderShape.fillColor = nil;
        borderShape.strokeColor = UIColor.blackColor.CGColor;
        borderShape.lineWidth = 2;
        borderShape.path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(view.frame, borderShape.lineWidth / 2, borderShape.lineWidth / 2) cornerRadius:cornerRadius-1].CGPath;
        borderGradient.mask = borderShape;
    } else {
        // Single border
        borderGradient.frame = CGRectMake(0, self.borderView.frame.size.height - 3, self.borderView.frame.size.width, 3);
    }

    // Shadow
	materialView.layer.shadowOpacity = 1.0;
	materialView.layer.shadowOffset = CGSizeZero;
	materialView.layer.shadowRadius = 5;
	materialView.layer.shadowColor = UIColor.blackColor.CGColor;

    // Title
    NSArray *titleColors = @[(id)[UIColor colorWithRed: 0.25 green: 0.79 blue: 1.00 alpha: 1.00].CGColor, (id)[UIColor colorWithRed: 0.91 green: 0.11 blue: 1.00 alpha: 1.00].CGColor];
    UIColor *titleGradient = [UIColor colorFromGradient:titleColors withEndpoint:CGPointMake(1, 0) inFrame:materialView.frame];
    title.textColor = titleGradient;

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