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

	CGFloat headerHeight = 100;
	self.table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.table.frame.size.width, headerHeight + 16)];

	UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, self._contentOverlayInsets.top, self.view.frame.size.width, headerHeight)];
	header.backgroundColor = UIColor.systemBackgroundColor;

	MTMaterialView *materialView = [NSClassFromString(@"MTMaterialView") materialViewWithRecipe:1 configuration:0];
	materialView.frame = CGRectMake(0, 0, 355, 75.3);
	materialView.center = CGPointMake(header.frame.size.width / 2, header.frame.size.height / 2);
	materialView.layer.cornerRadius = 19;
	materialView.layer.continuousCorners = YES;
	[header insertSubview:materialView atIndex:0];
	self.materialView = materialView;

	UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(materialView.frame.origin.x + 58, materialView.frame.origin.y + 10.3, 203, 18)];
	title.text = @"Notification Title";
	title.font = [UIFont boldSystemFontOfSize:15];
	[header insertSubview:title atIndex:1];
	self.titleLabel = title;

	UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(materialView.frame.origin.x + 58, materialView.frame.origin.y + 28.6, 283, 36)];
	message.text = @"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy est.";
	message.font = [message.font fontWithSize:15];
	message.numberOfLines = 2;
	message.lineBreakMode = NSLineBreakByWordWrapping;
	[header insertSubview:message atIndex:1];
	self.messageLabel = message;

	UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(materialView.frame.origin.x + 306, materialView.frame.origin.y + 11.3, 34.3, 16)];
	date.text = @"now";
	date.font = [date.font fontWithSize:13];
	date.textAlignment = NSTextAlignmentRight;
	date.textColor = [UIColor.labelColor colorWithAlphaComponent:0.5];
	[header insertSubview:date atIndex:1];
	self.dateLabel = date;

	[self.view insertSubview:header atIndex:1];
}
@end