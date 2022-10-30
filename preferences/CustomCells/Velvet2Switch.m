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

-(void)layoutSubviews {
    [super layoutSubviews];
    if (self.specifier.properties[@"systemIcon"]) {
        self.textLabel.frame = CGRectMake(60, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
        self.detailTextLabel.frame = CGRectMake(60, self.detailTextLabel.frame.origin.y, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);

    }
}
@end