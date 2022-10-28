#import "Headers/Headers.h"

@implementation Velvet2SettingsController

- (NSArray *)specifiers {
	if (!_specifiers) {
		NSMutableArray *mutableSpecifiers = [[self loadSpecifiersFromPlistName:@"Settings" target:self] mutableCopy];

		for (PSSpecifier *spec in [mutableSpecifiers reverseObjectEnumerator]) {
			spec.properties[@"key"] = [NSString stringWithFormat:@"%@_%@", spec.properties[@"key"], self.identifier ? self.identifier : @"global"];
		}

		_specifiers = mutableSpecifiers;
	}

	return _specifiers;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	[super setPreferenceValue:value specifier:specifier];
	[self updatePreview];
}

-(void)updatePreview {
	NSInteger aRedValue = arc4random()%255;
	NSInteger aGreenValue = arc4random()%255;
	NSInteger aBlueValue = arc4random()%255;

	UIColor *randColor = [UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:1.0f];
	self.materialView.layer.borderColor = randColor.CGColor;
	self.materialView.layer.borderWidth = 2;
}

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];

	if ([self.view.subviews count] > 1) return;

	CGFloat headerHeight = 93;
	self.table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.table.frame.size.width, headerHeight + (self.identifier ? 0 : 16))]; // Make room after notification

	UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, self._contentOverlayInsets.top, self.view.frame.size.width, headerHeight)];
	header.backgroundColor = UIColor.systemGroupedBackgroundColor;

	UIView *notificationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 355, 75.3)];
	notificationView.center = CGPointMake(header.frame.size.width / 2, header.frame.size.height / 2);
	[header insertSubview:notificationView atIndex:0];
	self.notificationView = notificationView;

	MTMaterialView *materialView = [NSClassFromString(@"MTMaterialView") materialViewWithRecipe:1 configuration:0];
	materialView.frame = CGRectMake(0, 0, 355, 75.3);
	// materialView.center = CGPointMake(header.frame.size.width / 2, header.frame.size.height / 2 - 16);
	materialView.layer.cornerRadius = 19;
	materialView.layer.continuousCorners = YES;
	[notificationView insertSubview:materialView atIndex:0];
	self.materialView = materialView;

	UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(materialView.frame.origin.x + 58, materialView.frame.origin.y + 10.3, 203, 18)];
	title.text = @"Notification Title";
	title.font = [UIFont boldSystemFontOfSize:15];
	[notificationView insertSubview:title atIndex:1];
	self.titleLabel = title;

	UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(materialView.frame.origin.x + 58, materialView.frame.origin.y + 28.6, 283, 36)];
	message.text = @"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy est.";
	message.font = [message.font fontWithSize:15];
	message.numberOfLines = 2;
	message.lineBreakMode = NSLineBreakByWordWrapping;
	[notificationView insertSubview:message atIndex:1];
	self.messageLabel = message;

	UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(materialView.frame.origin.x + 306, materialView.frame.origin.y + 11.3, 34.3, 16)];
	date.text = @"now";
	date.font = [date.font fontWithSize:13];
	date.textAlignment = NSTextAlignmentRight;
	date.textColor = [UIColor.labelColor colorWithAlphaComponent:0.5];
	[notificationView insertSubview:date atIndex:1];
	self.dateLabel = date;

	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(materialView.frame.origin.x + 10, materialView.frame.origin.y + 18.6, 38, 38)];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	[notificationView insertSubview:imageView atIndex:1];
	self.appIcon = imageView;

	if (!self.identifier) {
		UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleHeaderTouch:)];
		[notificationView addGestureRecognizer:singleFingerTap];

		UILabel *hint = [[UILabel alloc] initWithFrame:CGRectMake(0, header.frame.origin.y + header.frame.size.height, header.frame.size.width, 24)];
		hint.text = @"Tap notification to change the icon";
		hint.font = [hint.font fontWithSize:13];
		hint.textColor = UIColor.systemGrayColor;
		hint.textAlignment = NSTextAlignmentCenter;
		hint.backgroundColor = UIColor.systemGroupedBackgroundColor;
		[self.view insertSubview:hint atIndex:1];
	}
	
	[self.view insertSubview:header atIndex:1];

	[self updateAppIconWithIdentifier:nil];
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

	self.appIcon.image = [UIImage _applicationIconImageForBundleIdentifier:identifier format:2 scale:UIScreen.mainScreen.scale];
	[self updatePreview];
}

-(void)handleHeaderTouch:(UITapGestureRecognizer *)recognizer {
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
@end