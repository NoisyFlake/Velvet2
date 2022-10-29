@interface Velvet2ColorPicker : PSTableCell <UIColorPickerViewControllerDelegate>
@property (nonatomic, retain) UIView *cellColorDisplay;
@property (nonatomic, retain) UIColor *selectedColor;
-(void)openColorPicker;
@end