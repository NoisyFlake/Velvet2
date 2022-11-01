#import "../headers/HeadersPreferences.h"

@implementation Velvet2CustomizationController

- (NSArray *)specifiers {
	if (!_specifiers) {
        _specifiers = [self visibleSpecifiersFromPlist:@"Customization"];
	}

	return _specifiers;
}

@end