#import "../headers/HeadersPreferences.h"

@implementation Velvet2PreviewView

-(instancetype)initWithFrame:(CGRect)frame notificationWidth:(CGFloat)width identifier:(NSString *)identifier {
    self = [super initWithFrame:frame];

    self.identifier = identifier;
    self.backgroundColor = UIColor.systemBackgroundColor;

    UIView *notificationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 75.3)];
	notificationView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
	[self insertSubview:notificationView atIndex:0];
	self.notificationView = notificationView;

	MTMaterialView *materialView = [NSClassFromString(@"MTMaterialView") materialViewWithRecipe:1 configuration:0];
	materialView.frame = CGRectMake(0, 0, width, 75.3);
	[notificationView insertSubview:materialView atIndex:0];
	self.materialView = materialView;

	UIView *velvetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 75.3)];
	[notificationView insertSubview:velvetView atIndex:1];
	self.velvetView = velvetView;

	UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(materialView.frame.origin.x + 58, materialView.frame.origin.y + 10.3, 203, 18)];
	title.text = @"Notification Title";
	title.font = [UIFont boldSystemFontOfSize:15];
	[notificationView insertSubview:title atIndex:2];
	self.titleLabel = title;

	UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(materialView.frame.origin.x + 58, materialView.frame.origin.y + 28.6, 283, 36)];
	message.text = @"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy est.";
	message.font = [message.font fontWithSize:15];
	message.numberOfLines = 2;
	message.lineBreakMode = NSLineBreakByWordWrapping;
	[notificationView insertSubview:message atIndex:2];
	self.messageLabel = message;

	UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(materialView.frame.origin.x + materialView.frame.size.width - 15 - 34.3, materialView.frame.origin.y + 11.3, 34.3, 16)];
	date.text = @"now";
	date.font = [date.font fontWithSize:13];
	date.textAlignment = NSTextAlignmentRight;
	date.textColor = [UIColor.labelColor colorWithAlphaComponent:0.5];
	[notificationView insertSubview:date atIndex:2];
	self.dateLabel = date;

	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(materialView.frame.origin.x + 10, materialView.frame.origin.y + 18.6, 38, 38)];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	[notificationView insertSubview:imageView atIndex:2];
	self.appIcon = imageView;

    [self updateAppIconWithIdentifier:self.identifier];

	if (!self.identifier) {
		UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTouch:)];
		[notificationView addGestureRecognizer:singleFingerTap];

		UILabel *hint = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.size.height, self.frame.size.width, 24)];
		hint.text = @"Tap notification to change the icon";
		hint.font = [hint.font fontWithSize:13];
		hint.textColor = UIColor.systemGrayColor;
		hint.textAlignment = NSTextAlignmentCenter;
		hint.backgroundColor = UIColor.systemGroupedBackgroundColor;
		[self insertSubview:hint atIndex:1];
	}

    return self;
}

-(void)updatePreview {
    NSString *identifier = self.identifier;
	Velvet2PrefsManager *prefsManager = [NSClassFromString(@"Velvet2PrefsManager") sharedInstance];

	Velvet2Colorizer *colorizer = [[Velvet2Colorizer alloc] initWithIdentifier:identifier];
    colorizer.appIcon = self.appIcon.image;

	[UIView animateWithDuration:0.1 animations:^{
		CGFloat cornerRadius = [[prefsManager settingForKey:@"cornerRadiusEnabled" withIdentifier:identifier] boolValue] ? [[prefsManager settingForKey:@"cornerRadiusCustom" withIdentifier:identifier] floatValue] : 19;
		self.materialView.layer.continuousCorners = cornerRadius < self.materialView.frame.size.height / 2;
		self.materialView.layer.cornerRadius = MIN(cornerRadius, self.materialView.frame.size.height / 2);
		self.velvetView.layer.continuousCorners = cornerRadius < self.velvetView.frame.size.height / 2;
		self.velvetView.layer.cornerRadius = MIN(cornerRadius, self.velvetView.frame.size.height / 2);

		[colorizer colorBackground:self.velvetView];
		[colorizer colorBorder:self.velvetView];
	}];
}

-(void)updateAppIconWithIdentifier:(NSString*)identifier {
	if (!identifier) {
		LSApplicationWorkspace *workspace = [NSClassFromString(@"LSApplicationWorkspace") defaultWorkspace];
		NSArray *apps = [workspace allInstalledApplications];

		while(!identifier) {
			uint32_t rnd = arc4random_uniform([apps count]);
			LSApplicationProxy *app = [apps objectAtIndex:rnd];

			if ([app.applicationType isEqual:@"User"] || ([app.applicationType isEqual:@"System"] && ![app.appTags containsObject:@"hidden"] && !app.launchProhibited && !app.placeholder && !app.removedSystemApp)) {
				identifier = app.applicationIdentifier;
			}
		}
	}

	// Save the current identifier so we can use it in the sub- or parent controller
	Velvet2PrefsManager *manager = [NSClassFromString(@"Velvet2PrefsManager") sharedInstance];
	[manager setObject:identifier forKey:@"currentIcon"];
	self.currentIconIdentifier = identifier;

	self.appIcon.image = [UIImage _applicationIconImageForBundleIdentifier:identifier format:2 scale:UIScreen.mainScreen.scale];
	[self updatePreview];
}

-(void)handleTouch:(UITapGestureRecognizer *)recognizer {
	AudioServicesPlaySystemSound(1519);

	[UIView animateWithDuration:0.05 animations:^{
		self.notificationView.transform = CGAffineTransformMakeScale(1.05,1.05);
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.05 animations:^{
			self.notificationView.transform = CGAffineTransformMakeScale(1.0,1.0);
		}];
	}];

	[self updateAppIconWithIdentifier:nil];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
	[super traitCollectionDidChange:previousTraitCollection];

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
		[self updatePreview];
	});
}

- (void)didMoveToWindow {
	[super didMoveToWindow];

	Velvet2PrefsManager *manager = [NSClassFromString(@"Velvet2PrefsManager") sharedInstance];
	NSString *currentIcon = [manager settingForKey:@"currentIcon" withIdentifier:nil];
	if (currentIcon) {
		// This causes the icon to update correctly in the SettingsController when returning from a sub-controller
		[self updateAppIconWithIdentifier:currentIcon];
	}	
}

@end