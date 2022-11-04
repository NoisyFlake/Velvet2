#import "../headers/HeadersPreferences.h"

@implementation Velvet2PreviewController

- (NSMutableArray*)visibleSpecifiersFromPlist:(NSString*)plist {
	Velvet2PrefsManager *manager = [NSClassFromString(@"Velvet2PrefsManager") sharedInstance];

	NSMutableArray *mutableSpecifiers = [[self loadSpecifiersFromPlistName:plist target:self] mutableCopy];

	for (PSSpecifier *specifier in [mutableSpecifiers reverseObjectEnumerator]) {
		NSString *requirement = specifier.properties[@"require"];

		if (requirement) {
			NSArray *requirementList = [requirement componentsSeparatedByString:@"&"];
			for (NSString *singleRequirement in requirementList) {
				if ([singleRequirement containsString:@"="]) {
					NSArray *kv = [singleRequirement componentsSeparatedByString:@"="];
					if (![[manager settingForKey:kv[0] withIdentifier:self.identifier] isEqual:kv[1]]) {
						[mutableSpecifiers removeObject:specifier];
						break;
					} 
				} else {
					if (![[manager settingForKey:singleRequirement withIdentifier:self.identifier] boolValue]) {
						[mutableSpecifiers removeObject:specifier];
						break;
					}
				}
			}
		}
	}

	return mutableSpecifiers;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	if (self.identifier) {
		specifier.properties[@"key"] = [NSString stringWithFormat:@"%@_%@", specifier.properties[@"key"], self.identifier];
	}

	[super setPreferenceValue:value specifier:specifier];
	[self.preview updatePreview];

	// This wouldn't usually be necessary, but I don't want to write the update string into every Specifier in the plist
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"com.noisyflake.velvet2/preferenceUpdate", NULL, NULL, YES);

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
		[self reloadSpecifiers];
	});
	
}

-(id)readPreferenceValue:(PSSpecifier*)specifier {
	Velvet2PrefsManager *manager = [NSClassFromString(@"Velvet2PrefsManager") sharedInstance];
	return [manager settingForKey:specifier.properties[@"key"] withIdentifier:self.identifier];
}

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];

	if ([self.view.subviews count] > 1) return;

	CGFloat notificationWidth = self.table.subviews[0].frame.size.width;

	CGRect previewFrame = CGRectMake(0, self._contentOverlayInsets.top, self.view.frame.size.width, 93 + 30);
	self.preview = [[Velvet2PreviewView alloc] initWithFrame:previewFrame notificationWidth:notificationWidth identifier:self.identifier];

	if ([self.navigationController.previousViewController isKindOfClass:NSClassFromString(@"Velvet2SettingsController")]) {
		// Use the same icon that our parent displayed
		// self.preview.disableAnimationOnce = YES;
		[self.preview updateAppIconWithIdentifier:((Velvet2SettingsController *)self.navigationController.previousViewController).preview.currentIconIdentifier];
	}

	[self.view insertSubview:self.preview atIndex:1];

	// Need additional space if we don't have a group label first
	CGFloat additionalHeight = [self specifierAtIndex:0].name ? 0 : 32;

	self.table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, notificationWidth, 93 + additionalHeight + (self.identifier ? 0 : 16))]; // Make room after notification
}
@end