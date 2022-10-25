#import "Headers/Tweak.h"

%hook NCNotificationShortLookViewController
%property (nonatomic,retain) UIView *borderView;

-(void)viewDidLoad {
    %orig;

    NCNotificationShortLookView *view = (NCNotificationShortLookView *)self.viewForPreview;

    UIView *borderView = [UIView new];

    CAShapeLayer *gradientShape = [CAShapeLayer new];
    gradientShape.fillColor = nil;
    gradientShape.strokeColor = UIColor.blackColor.CGColor;

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.mask = gradientShape;
    [borderView.layer insertSublayer:gradientLayer atIndex:0];

    [view.backgroundMaterialView.superview insertSubview:borderView atIndex:2];
    self.borderView = borderView;
}
-(void)viewDidLayoutSubviews {
    %orig;

    // NSLog(@"Notification: %@", self.notificationRequest.sectionIdentifier);

    NCNotificationShortLookView *view = (NCNotificationShortLookView *)self.viewForPreview;
    MTMaterialView *materialView = view.backgroundMaterialView;

    if (materialView.frame.size.width == 0) return;

    CGFloat cornerRadius = MIN(40, materialView.frame.size.height / 2);

    view.layer.cornerRadius = cornerRadius;
    materialView.layer.cornerRadius = cornerRadius;
    materialView.superview.layer.cornerRadius = cornerRadius;

    CAGradientLayer *gradientLayer = self.borderView.layer.sublayers[0];
    CAShapeLayer *gradientShape = gradientLayer.mask;

    self.borderView.frame = materialView.frame;
    self.borderView.layer.continuousCorners = YES;

    // Background
    materialView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.3];

    // Full Border (Gradient)
    gradientLayer.frame = self.borderView.frame;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.colors = @[(id)[UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor, (id)[UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor];

    gradientShape.lineWidth = 1;
    gradientShape.path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.borderView.frame, 0.5, 0.5) cornerRadius:materialView.layer.cornerRadius].CGPath;
    
    // Full Border (Single color)
    // self.borderView.layer.borderWidth = 2;
    // self.borderView.layer.borderColor = UIColor.whiteColor.CGColor;

    // Single Border (single color)
    // self.borderView.layer.sublayers[0].frame = CGRectMake(0.0f, 0.0f, 3.0f, self.borderView.frame.size.height);
    // self.borderView.layer.sublayers[0].backgroundColor = [UIColor redColor].CGColor;
    

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