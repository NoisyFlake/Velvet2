#import "Headers/Tweak.h"

%hook NCNotificationShortLookViewController
%property (nonatomic,retain) UIView *borderView;

-(void)viewDidLoad {
    %orig;

    NCNotificationShortLookView *view = (NCNotificationShortLookView *)self.viewForPreview;

    UIView *borderView = [UIView new];
    borderView.clipsToBounds = YES;

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    [borderView.layer insertSublayer:gradientLayer atIndex:0];

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
    CAGradientLayer *gradientLayer = self.borderView.layer.sublayers[0];

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
    // materialView.backgroundColor = [UIColor.redColor colorWithAlphaComponent:1.0];

    // Gradient border
    self.borderView.frame = materialView.frame;
    gradientLayer.frame = self.borderView.frame;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.colors = @[(id)[UIColor colorWithRed: 0.25 green: 0.79 blue: 1.00 alpha: 1.00].CGColor, (id)[UIColor colorWithRed: 0.91 green: 0.11 blue: 1.00 alpha: 1.00].CGColor];

    if (YES) {
        // Full border
        CAShapeLayer *gradientShape = [CAShapeLayer new];
        gradientShape.fillColor = nil;
        gradientShape.strokeColor = UIColor.blackColor.CGColor;
        gradientShape.lineWidth = 2;
        gradientShape.path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(view.frame, gradientShape.lineWidth / 2, gradientShape.lineWidth / 2) cornerRadius:cornerRadius].CGPath;
        gradientLayer.mask = gradientShape;
    } else {
        // Single border
        gradientLayer.frame = CGRectMake(0, self.borderView.frame.size.height - 3, self.borderView.frame.size.width, 3);
    }

    // Shadow
	// materialView.layer.shadowOpacity = 1.0;
	// materialView.layer.shadowOffset = CGSizeZero;
	// materialView.layer.shadowRadius = 5;
	// materialView.layer.shadowColor = UIColor.whiteColor.CGColor;

    // Title
    // NCNotificationSeamlessContentView *contentView = [view valueForKey:@"notificationContentView"];
    // UILabel *title = [contentView valueForKey:@"primaryTextLabel"];
    // title.textColor = UIColor.cyanColor;

    // Message
    // UILabel *message = [contentView valueForKey:@"secondaryTextElement"];
    // message.textColor = UIColor.redColor;
    // message.textAlignment = NSTextAlignmentCenter;

    // Date
    // UILabel *dateLabel = [contentView valueForKey:@"dateLabel"];
    // dateLabel.textColor = UIColor.redColor;
    // dateLabel.layer.filters = nil;
}
%end