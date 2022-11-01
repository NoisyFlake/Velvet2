#import "../headers/HeadersPreferences.h"

@implementation Velvet2PreviewController

- (NSMutableArray*)visibleSpecifiersFromPlist:(NSString*)plist {
	Velvet2PrefsManager *manager = [NSClassFromString(@"Velvet2PrefsManager") sharedInstance];

	NSMutableArray *mutableSpecifiers = [[self loadSpecifiersFromPlistName:plist target:self] mutableCopy];

	for (PSSpecifier *specifier in [mutableSpecifiers reverseObjectEnumerator]) {
		NSString *requirement = specifier.properties[@"require"];
		if (requirement) {
			if ([requirement containsString:@"="]) {
				NSArray *kv = [requirement componentsSeparatedByString:@"="];
				if (![[manager settingForKey:kv[0] withIdentifier:self.identifier] isEqual:kv[1]]) [mutableSpecifiers removeObject:specifier];
			} else {
				if (![[manager settingForKey:requirement withIdentifier:self.identifier] boolValue]) [mutableSpecifiers removeObject:specifier];
			}
		}
	}

	return mutableSpecifiers;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
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

	CGRect previewFrame = CGRectMake(0, self._contentOverlayInsets.top, self.view.frame.size.width, 93);
	self.preview = [[Velvet2PreviewView alloc] initWithFrame:previewFrame notificationWidth:notificationWidth identifier:self.identifier];

	if ([self.navigationController.previousViewController isKindOfClass:NSClassFromString(@"Velvet2SettingsController")]) {
		// Use the same icon that our parent displayed
		[self.preview updateAppIconWithIdentifier:((Velvet2SettingsController *)self.navigationController.previousViewController).preview.currentIconIdentifier];
	}

	[self.view insertSubview:self.preview atIndex:1];

	self.table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, notificationWidth, 93 + (self.identifier ? 0 : 16))]; // Make room after notification
}
@end