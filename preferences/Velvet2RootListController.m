#import "../headers/HeadersPreferences.h"

@implementation Velvet2RootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];

	[self setupHeader];
	[self setupFooterVersion];
}

-(void)setupHeader {
	UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 140)];

    UIImage *image = [UIImage imageNamed:@"velvet-header-icon.png" inBundle:[NSBundle bundleForClass:NSClassFromString(@"Velvet2RootListController")] compatibleWithTraitCollection:nil];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30 - 4, self.view.bounds.size.width, 80)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView setImage:image];

    [header addSubview:imageView];
	self.table.tableHeaderView = header;
}

-(void)setupFooterVersion {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSPipe *pipe = [NSPipe pipe];

		NSTask *task = [[NSTask alloc] init];
		task.arguments = @[@"-c", @"dpkg -s com.noisyflake.velvet2 | grep -i version | cut -d' ' -f2"];
		task.launchPath = @"/bin/sh";
		[task setStandardOutput: pipe];
		[task launch];
		[task waitUntilExit];

		NSFileHandle *file = [pipe fileHandleForReading];
		NSData *output = [file readDataToEndOfFile];
		NSString *outputString = [[NSString alloc] initWithData:output encoding:NSUTF8StringEncoding];
		outputString = [outputString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		[file closeFile];

		dispatch_async(dispatch_get_main_queue(), ^(void){
			// Update specifier on the main queue
			if ([outputString length] > 0) {
				PSSpecifier *spec = [self specifierForID:@"footer"];
				[spec setProperty:[NSString stringWithFormat:@"Version %@\nDeveloped with \u2665 by NoisyFlake", outputString] forKey:@"footerText"];
				[self reloadSpecifierID:@"footer" animated:NO];
			}
		});
	});
}

-(void)resetSettings {
	[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:@"com.noisyflake.velvet2"];
	[self reload];

	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"com.noisyflake.velvet2/preferenceUpdate", NULL, NULL, YES);
}

-(void)showController:(id)controller {
	
	// if ([controller isKindOfClass:NSClassFromString(@"Velvet2SettingsController")]) {
	// 	((Velvet2SettingsController *)controller).identifier = @"globaltest";
	// }
	return [super showController:controller]; 
}
@end
