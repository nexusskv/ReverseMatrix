//
//  MatrixViewController.m
//  ReversedMatrix
//
//  Created by Rost on 23.10.16.
//  Copyright © 2016 Rost Gress. All rights reserved.
//

#import "MatrixViewController.h"

@interface MatrixViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *pitchImageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *sourceField;
@property (weak, nonatomic) IBOutlet UILabel *matrixLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typesSegment;
@end


@implementation MatrixViewController

    /* ---> View life cycle <--- */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int radiusNumber = self.pitchImageView.frame.size.height / 2;
    self.pitchImageView.layer.cornerRadius  = radiusNumber;
    self.pitchImageView.layer.masksToBounds = YES;
    
    radiusNumber = self.logoImageView.frame.size.width / 4;
    self.logoImageView.layer.cornerRadius   = 50;
    self.logoImageView.layer.masksToBounds  = YES;
}

    /* ---> Actions <--- */

- (IBAction)segmentSwitch:(UISegmentedControl *)sender {
    [self createMatrix];
}

    /* ---> Selectors <--- */

- (void)createMatrix {
    if (self.sourceField.text.length > 0) {
        NSCharacterSet *sourceSet  = [NSCharacterSet characterSetWithCharactersInString:self.sourceField.text];
        NSCharacterSet *numbersSet = [NSCharacterSet decimalDigitCharacterSet];
        
        if([numbersSet isSupersetOfSet:sourceSet]) {

            if ([self.sourceField.text intValue] > 19) {
                [self showAlert:@"Please a number less than 20"];
                return;
            }
            
            self.matrixLabel.numberOfLines = [self.sourceField.text intValue] + 1;

            NSArray *matrixArray = nil;

            switch (self.typesSegment.selectedSegmentIndex) {
                case 0: {
                    matrixArray = [self createMatrixWithLimit:[self.sourceField.text intValue]
                                                      andBack:NO
                                                   andReverse:NO];
                }
                    break;
                    
                case 1: {
                    matrixArray = [self createMatrixWithLimit:[self.sourceField.text intValue]
                                                      andBack:NO
                                                   andReverse:YES];
                }
                    break;
                    
                case 2: {
                    matrixArray = [self createMatrixWithLimit:[self.sourceField.text intValue]
                                                      andBack:YES
                                                   andReverse:NO];
                }
                    break;
                    
                case 3: {
                    matrixArray = [self createMatrixWithLimit:[self.sourceField.text intValue]
                                                      andBack:YES
                                                   andReverse:YES];
                }
                    break;
                    
                default:
                    break;
            }
            
            if (matrixArray) {
                NSMutableAttributedString *rowString = [[NSMutableAttributedString alloc] init];
                NSAttributedString *divideString = [[NSAttributedString alloc] initWithString:@"\n"];
                
                for (NSAttributedString *attributedString in matrixArray) {
                    [rowString appendAttributedString:attributedString];
                    [rowString appendAttributedString:divideString];
                }
                
                self.matrixLabel.attributedText = rowString;
            } else {
                [self showAlert:@"Please enter a number and create matrix"];
            }

        } else {
            [self showAlert:@"Please enter a number only"];
        }
        
    }
}

- (NSArray *)createMatrixWithLimit:(NSUInteger)limit andBack:(BOOL)back andReverse:(BOOL)reverse {
    NSMutableArray *matrixMutableArray = [NSMutableArray array];

    NSMutableAttributedString *orderString = [[self createMatrixString:YES] copy];
    NSMutableAttributedString *emptyString = [[self createMatrixString:NO] copy];
 
    int count     = 0;
    int backCount = (int)limit;
    for (int i = 0; i < limit; i++) {
        NSMutableAttributedString *rowString = [[NSMutableAttributedString alloc] init];
        
        count += 1;

        for (int m = 0; m < limit; m++) {
            if (back) {
                count = backCount;
            }
            
            if (!reverse) {
                if (m < count) {
                    [rowString appendAttributedString:orderString];
                } else {
                    [rowString insertAttributedString:emptyString atIndex:m];
                }
            } else {
                if (m < (limit - count)) {
                    [rowString appendAttributedString:emptyString];
                } else {
                    [rowString insertAttributedString:orderString atIndex:m];
                }
            }
        }
        
        backCount -= 1;
        
        [matrixMutableArray addObject:rowString];
    }
    
    return matrixMutableArray;
}

    /* ---> Help selectors <--- */

- (NSAttributedString *)createMatrixString:(BOOL)flag {
    // LOG SPACE VS CHARARTER WIDTH DIFFERENT
    // CGSize textSize = [emptyString sizeWithAttributes: userAttributes];
    // @" " (CGSize) textSize = (width = 5.556640625, height = 22.34375)
    // @"_" (CGSize) textSize = (width = 11.123046875, height = 22.34375)
    
    if (flag) {
        NSDictionary *orderAttributes = @{NSFontAttributeName:              self.matrixLabel.font,
                                          NSForegroundColorAttributeName:   [UIColor greenColor]};
        return [[NSMutableAttributedString alloc] initWithString:@"#"
                                                      attributes:orderAttributes];
    } else {
        NSDictionary *clearAttributes = @{NSFontAttributeName:              self.matrixLabel.font,
                                          NSForegroundColorAttributeName:   [UIColor clearColor]};
        return [[NSMutableAttributedString alloc] initWithString:@"_"
                                                      attributes:clearAttributes];
    }
}

- (void)showAlert:(NSString *)message {
    UIAlertController *messageAC = [UIAlertController
                                 alertControllerWithTitle:@"Error message."
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];

    
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [messageAC dismissViewControllerAnimated:YES completion:nil];
                                                     }];
    [messageAC addAction:okButton];
    
    [self presentViewController:messageAC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
