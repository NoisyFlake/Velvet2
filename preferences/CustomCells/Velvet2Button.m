#import "../../headers/HeadersPreferences.h"

@implementation Velvet2Button
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
		if (specifier.properties[@"systemIcon"]) {
            UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithFont:[UIFont systemFontOfSize:25]];
            UIImage *image = [UIImage systemImageNamed:specifier.properties[@"systemIcon"] withConfiguration:config];
            [specifier setProperty:image forKey:@"iconImage"];

            self.imageView.tintColor = kVelvetColor;
        }
	}

	return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];

    self.textLabel.textColor = UIColor.labelColor;
    self.textLabel.highlightedTextColor = UIColor.labelColor;

    if (self.specifier.properties[@"systemIcon"]) {
        self.textLabel.frame = CGRectMake(60, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
    }

    PSListController *controller = [self _viewControllerForAncestor];
    if ([controller isKindOfClass:NSClassFromString(@"Velvet2PreviewController")]) {
        Velvet2PreviewController *previewController = (Velvet2PreviewController *)controller;

        if (previewController.identifier && [previewController appSettingForKeyExists:self.specifier.properties[@"key"]]) {
            self.backgroundColor = [kVelvetColor colorWithAlphaComponent:0.3];
        }
    }
}
@end