#import "../../headers/HeadersPreferences.h"

@implementation Velvet2LinkCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
        // if (specifier.properties[@"systemIcon"]) {
        //     UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithFont:[UIFont systemFontOfSize:24]];
        //     self.imageView.image = [UIImage systemImageNamed:self.specifier.properties[@"systemIcon"] withConfiguration:config];
        //     self.imageView.tintColor = kVelvetColor;
        // }
	}

	return self;
}

-(void)didMoveToWindow {
    [super didMoveToWindow];

    if (self.specifier.properties[@"systemIcon"]) {
        UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithFont:[UIFont systemFontOfSize:24]];
        self.imageView.image = [UIImage systemImageNamed:self.specifier.properties[@"systemIcon"] withConfiguration:config];
        self.imageView.tintColor = kVelvetColor;

        // self.imageView.contentMode = UIViewContentModeCenter;

        // self.imageView.frame = CGRectMake(13, self.imageView.superview.frame.size.height / 2 - (29 / 2), 29, 29);
    }
}
@end