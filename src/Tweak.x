#import "Headers/Tweak.h"

%hook NCNotificationShortLookViewController
%property (nonatomic,retain) UIView *borderView;

-(void)viewDidLayoutSubviews {
    %orig;

    NSLog(@"Notification: %@", self.notificationRequest.sectionIdentifier);

    NCNotificationShortLookView *view = (NCNotificationShortLookView *)self.viewForPreview;
    MTMaterialView *materialView = view.backgroundMaterialView;

    if (materialView.frame.size.width == 0) return;

    view.layer.cornerRadius = 35;
    materialView.layer.cornerRadius = 35;
    materialView.superview.layer.cornerRadius = 35;

    // CAGradientLayer *gradientLayer;
    // CAShapeLayer *gradientShape;

    if (self.borderView == nil) {
        UIView *borderView = [[UIView alloc] initWithFrame:materialView.frame];
        borderView.layer.cornerRadius = materialView.layer.cornerRadius;
        borderView.layer.continuousCorners = YES;
        [materialView.superview insertSubview:borderView atIndex:1];
        
        self.borderView = borderView;

        // gradientLayer = [CAGradientLayer layer];
        // gradientLayer.startPoint = CGPointMake(0, 0);
        // gradientLayer.endPoint = CGPointMake(1, 0);

        // CAShapeLayer *gradientShape =[[CAShapeLayer alloc] init];
        // gradientShape.fillColor = nil;
        // gradientShape.strokeColor = [UIColor blackColor].CGColor;
        // gradientShape.lineWidth = 3;
        // gradientShape.path = [UIBezierPath bezierPathWithRoundedRect:self.borderView.frame cornerRadius:self.borderView.layer.cornerRadius].CGPath;
        // gradientLayer.mask = gradientShape;

        // self.borderView.layer.masksToBounds = YES;

        // [self.borderView.layer insertSublayer:gradientLayer atIndex:0];
    } else {
        // gradientLayer = self.borderView.layer.sublayers[0];
        // gradientShape = gradientLayer.mask;
    }

    self.borderView.frame = materialView.frame;
    self.borderView.layer.borderWidth = 2;
    self.borderView.layer.borderColor = UIColor.whiteColor.CGColor;

    // Background
    materialView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.3];

    // Border
    // gradientLayer.frame = self.borderView.frame;
    // gradientLayer.colors = @[(id)[UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor, (id)[UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor];
    // gradientShape.lineWidth = 3;
    // gradientShape.path = [UIBezierPath bezierPathWithRoundedRect:self.borderView.frame cornerRadius:self.borderView.layer.cornerRadius].CGPath;
    
    // Shadow
	materialView.layer.shadowOpacity = 1.0;
	materialView.layer.shadowOffset = CGSizeZero;
	materialView.layer.shadowRadius = 5;
	materialView.layer.shadowColor = UIColor.whiteColor.CGColor;

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