#import <Preferences/PSListController.h>
#import <spawn.h>

@interface Velvet2RootListController : PSListController
-(void)setupHeader;
-(void)setupFooterVersion;
-(void)resetSettings;
-(void)twitter;
-(void)paypal;
-(void)setTweakEnabled:(id)value specifier:(PSSpecifier *)specifier;
-(void)respring;
@end
