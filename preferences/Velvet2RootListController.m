#import <Foundation/Foundation.h>
#import "Velvet2RootListController.h"

@implementation Velvet2RootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

@end
