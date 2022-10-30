#import "../../headers/HeadersPreferences.h"

@implementation Velvet2Switch
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
		[((UISwitch *)[self control]) setOnTintColor:kVelvetColor];
	}

	return self;
}

-(id)imageView {
    UIImageView *imageView = [super imageView];

    if (self.specifier.properties[@"systemIcon"]) {
        UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithFont:[UIFont systemFontOfSize:25]];
        imageView.image = [UIImage systemImageNamed:self.specifier.properties[@"systemIcon"] withConfiguration:config];
        imageView.tintColor = kVelvetColor;
    }

    return imageView;
}
@end