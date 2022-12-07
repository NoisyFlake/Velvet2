#import "../headers/HeadersPreferences.h"

@implementation Velvet2AppSelectController

- (NSArray *)specifiers {
	if (!_specifiers) {
        NSMutableArray *mutableSpecifiers = [NSMutableArray new];
		
        LSApplicationWorkspace *workspace = [NSClassFromString(@"LSApplicationWorkspace") defaultWorkspace];
		NSArray *apps = [workspace allInstalledApplications];

        for (LSApplicationProxy *app in apps) {
            if ([app.applicationType isEqual:@"User"] || ([app.applicationType isEqual:@"System"] && ![app.appTags containsObject:@"hidden"] && !app.launchProhibited && !app.placeholder && !app.removedSystemApp)) {

				if ([app.applicationIdentifier isEqual:@"com.apple.webapp"]) continue;

				PSSpecifier* specifier = [PSSpecifier preferenceSpecifierNamed:app.localizedName
										target:self
										set:@selector(setPreferenceValue:specifier:)
										get:@selector(readPreferenceValue:)
										detail:Nil
										cell:PSLinkCell
										edit:Nil];

				[specifier setProperty:app.applicationIdentifier forKey:@"key"];
				[specifier setProperty:app.localizedName forKey:@"label"];
				[specifier setProperty:@"com.noisyflake.velvet2" forKey:@"defaults"];
				[specifier setProperty:@"1" forKey:@"isController"];
				specifier.detailControllerClass = NSClassFromString(@"Velvet2SettingsController");

				[mutableSpecifiers addObject:specifier];

				UIImage *icon = [UIImage _applicationIconImageForBundleIdentifier:app.applicationIdentifier format:0 scale:UIScreen.mainScreen.scale];

				CGImageRef cgIcon = icon.CGImage;
				CGFloat scale = (CGImageGetWidth(cgIcon) + CGImageGetHeight(cgIcon)) / (CGFloat)(29 + 29);
				UIImage *iconResized = [UIImage imageWithCGImage:cgIcon scale:scale orientation:0];

				if (iconResized) {
					[specifier setProperty:iconResized forKey:@"iconImage"];
				}
				
            }
        }

        [mutableSpecifiers sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)]]];

        _specifiers = mutableSpecifiers;
	}

	return _specifiers;
}

-(void)showController:(id)controller {
	if ([controller isKindOfClass:NSClassFromString(@"Velvet2SettingsController")]) {
        NSIndexPath *selectedPath = self.table.indexPathForSelectedRow;
        PSTableCell *selectedCell = [self.table cellForRowAtIndexPath:selectedPath];
        PSSpecifier *specifier = selectedCell.specifier;

        ((Velvet2SettingsController *)controller).identifier = specifier.properties[@"key"];
		((Velvet2SettingsController *)controller).identifierName = specifier.name;
	}

	return [super showController:controller]; 
}

@end
