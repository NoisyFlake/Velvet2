#import "../../headers/HeadersPreferences.h"

@implementation Velvet2ColorPicker
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier specifier:specifier];

    [specifier setTarget:self];
    [specifier setButtonAction:@selector(openColorPicker)];

    self.cellColorDisplay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 31, 31)];
    self.cellColorDisplay.layer.cornerRadius = self.cellColorDisplay.frame.size.height / 2;
    self.cellColorDisplay.layer.borderWidth = 1;
    self.cellColorDisplay.layer.borderColor = UIColor.systemGrayColor.CGColor;
    [self setAccessoryView:self.cellColorDisplay];

    return self;
}

-(void)didMoveToSuperview {
    [super didMoveToSuperview];

    PSViewController *psController = (PSViewController*)[self _viewControllerForAncestor];
    NSString *colorString = [psController readPreferenceValue:self.specifier];
    self.selectedColor = [UIColor colorWithCIColor:[CIColor colorWithString:colorString]];

    self.cellColorDisplay.backgroundColor = self.selectedColor;
}

-(void)openColorPicker {
    PSViewController *psController = (PSViewController*)[self _viewControllerForAncestor];

    UIColorPickerViewController *colorPicker = [UIColorPickerViewController new];
    colorPicker.delegate = self;
    colorPicker.supportsAlpha = YES;
    colorPicker.selectedColor = self.selectedColor;
    [psController presentViewController:colorPicker animated:YES completion:nil];
}

- (void)colorPickerViewController:(UIColorPickerViewController *)viewController didSelectColor:(UIColor *)color continuously:(BOOL)continuously {
    if (!continuously) {
        self.selectedColor = color;
    }
}

- (void)colorPickerViewControllerDidFinish:(UIColorPickerViewController *)viewController {
    self.cellColorDisplay.backgroundColor = self.selectedColor;

    PSViewController *psController = (PSViewController*)[self _viewControllerForAncestor];
    NSString *colorString = [CIColor colorWithCGColor:self.selectedColor.CGColor].stringRepresentation;
    [psController setPreferenceValue:colorString specifier:self.specifier];
}

@end