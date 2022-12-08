#import "../headers/HeadersPreferences.h"

@implementation Velvet2SettingsController

- (NSArray *)specifiers {
	if (!_specifiers) {
	    _specifiers = [self visibleSpecifiersFromPlist:@"Settings"];

		NSMutableArray *mutableSpecifiers = [_specifiers mutableCopy];

		if ([self.identifier isEqual:@"com.noisyflake.velvetFocus"]) {
			for (PSSpecifier *specifier in [mutableSpecifiers reverseObjectEnumerator]) {
				NSString *key = specifier.properties[@"key"];
				if ([key isEqual:@"Line"] || [key isEqual:@"Date"] || [key isEqual:@"appIconCornerRadiusCircle"]) {
					specifier.properties[@"enabled"] = @NO;
				}
			}

			_specifiers = mutableSpecifiers;
		}
	}

	if (self.identifier && self.identifierName) {
	    self.title = self.identifierName;
	}

	return _specifiers;
}

-(void)showController:(id)controller {
	if ([controller isKindOfClass:NSClassFromString(@"Velvet2CustomizationController")]) {
        NSIndexPath *selectedPath = self.table.indexPathForSelectedRow;
        PSTableCell *selectedCell = [self.table cellForRowAtIndexPath:selectedPath];
        PSSpecifier *specifier = selectedCell.specifier;

        ((Velvet2CustomizationController *)controller).identifier = self.identifier;
        ((Velvet2CustomizationController *)controller).currentKey = specifier.properties[@"key"];
	}

	return [super showController:controller]; 
}

@end