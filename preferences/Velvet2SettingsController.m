#import "Headers/Headers.h"

@implementation Velvet2SettingsController

- (NSArray *)specifiers {
	if (!_specifiers) {
		Velvet2PrefsManager *manager = [NSClassFromString(@"Velvet2PrefsManager") sharedInstance];

		NSMutableArray *mutableSpecifiers = [[self loadSpecifiersFromPlistName:@"Settings" target:self] mutableCopy];

		for (PSSpecifier *specifier in [mutableSpecifiers reverseObjectEnumerator]) {
			if ([specifier.properties[@"key"] isEqual:@"cornerRadiusCustom"] && ![[manager settingForKey:@"cornerRadiusEnabled" withIdentifier:self.identifier] boolValue]) [mutableSpecifiers removeObject:specifier];
		}

		_specifiers = mutableSpecifiers;
	}

	return _specifiers;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	[super setPreferenceValue:value specifier:specifier];
	[self updatePreview];

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
		[self reloadSpecifiers];
	});
	
}

-(id)readPreferenceValue:(PSSpecifier*)specifier {
	Velvet2PrefsManager *manager = [NSClassFromString(@"Velvet2PrefsManager") sharedInstance];
	return [manager settingForKey:specifier.properties[@"key"] withIdentifier:self.identifier];
}

-(void)updatePreview {
	Velvet2PrefsManager *manager = [NSClassFromString(@"Velvet2PrefsManager") sharedInstance];

	CGFloat cornerRadiusCustom = [[manager settingForKey:@"cornerRadiusEnabled" withIdentifier:self.identifier] boolValue] ? [[manager settingForKey:@"cornerRadiusCustom" withIdentifier:self.identifier] floatValue] : 19;
	self.materialView.layer.continuousCorners = cornerRadiusCustom < self.materialView.frame.size.height / 2;
	self.materialView.layer.cornerRadius = MIN(cornerRadiusCustom, self.materialView.frame.size.height / 2);

	NSString *backgroundType = [manager settingForKey:@"backgroundType" withIdentifier:self.identifier];
	self.materialView.backgroundColor = [backgroundType isEqual:@"custom"] ? [manager colorForKey:@"backgroundColor" withIdentifier:self.identifier] : nil;
	self.materialView.layer.filters = nil; // TODO: Check if we might still need a filter like gaussian blur
}

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];

	if ([self.view.subviews count] > 1) return;

	CGFloat headerHeight = 93;
	self.table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.table.frame.size.width, headerHeight + (self.identifier ? 0 : 16))]; // Make room after notification

	UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, self._contentOverlayInsets.top, self.view.frame.size.width, headerHeight)];
	header.backgroundColor = UIColor.systemBackgroundColor;

	UIView *notificationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 355, 75.3)];
	notificationView.center = CGPointMake(header.frame.size.width / 2, header.frame.size.height / 2);
	[header insertSubview:notificationView atIndex:0];
	self.notificationView = notificationView;

	MTMaterialView *materialView = [NSClassFromString(@"MTMaterialView") materialViewWithRecipe:1 configuration:0];
	materialView.frame = CGRectMake(0, 0, 355, 75.3);
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

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
	[super traitCollectionDidChange:previousTraitCollection];

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
		[self updatePreview];
	});
}
@end