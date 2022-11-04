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
			// Insert footer on the main queue
			if ([outputString length] > 0) {
				NSString *firstLine = [NSString stringWithFormat:@"Velvet %@", outputString];

				NSMutableAttributedString *fullFooter =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\nwith \u2665 by NoisyFlake", firstLine]];

				[fullFooter beginEditing];
				[fullFooter addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, [firstLine length])];
				[fullFooter endEditing];
				
				UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
				footerLabel.font = [UIFont systemFontOfSize:13];
				footerLabel.textColor = UIColor.systemGrayColor;
				footerLabel.numberOfLines = 2;
				footerLabel.attributedText = fullFooter;
				footerLabel.textAlignment = NSTextAlignmentCenter;
				self.table.tableFooterView = footerLabel;
			}
		});
	});
}

-(void)resetSettings {
	[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:@"com.noisyflake.velvet2"];
	[self reload];

	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)@"com.noisyflake.velvet2/preferenceUpdate", NULL, NULL, YES);
}

-(void)twitter {
	NSURL *tweetbot = [NSURL URLWithString:@"tweetbot://NoisyFlake/user_profile/NoisyFlake"];
	NSURL *twitterrific = [NSURL URLWithString:@"twitterrific://profile?screen_name=NoisyFlake"];
	NSURL *twitter = [NSURL URLWithString:@"twitter://user?screen_name=NoisyFlake"];
	NSURL *web = [NSURL URLWithString:@"http://www.twitter.com/NoisyFlake"];
	
	if ([[UIApplication sharedApplication] canOpenURL:tweetbot]) {
        [[UIApplication sharedApplication] openURL:tweetbot options:@{} completionHandler:nil];
    } else if ([[UIApplication sharedApplication] canOpenURL:twitterrific]) {
        [[UIApplication sharedApplication] openURL:twitterrific options:@{} completionHandler:nil];
    } else if ([[UIApplication sharedApplication] canOpenURL:twitter]) {
        [[UIApplication sharedApplication] openURL:twitter options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:web options:@{} completionHandler:nil];
    }
}

-(void)paypal {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.paypal.me/NoisyFlake"] options:@{} completionHandler:nil];
}

-(void)setTweakEnabled:(id)value specifier:(PSSpecifier *)specifier {
	[self setPreferenceValue:value specifier:specifier];

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring)];
}

-(void)respring {
	pid_t pid;
	const char* args[] = {"sbreload", NULL};
	posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)args, NULL);
}

// -(void)showController:(id)controller {
	
// 	if ([controller isKindOfClass:NSClassFromString(@"Velvet2SettingsController")]) {
// 		((Velvet2SettingsController *)controller).identifier = @"com.apple.mobilecal";
// 	}

// 	return [super showController:controller]; 
// }
@end
