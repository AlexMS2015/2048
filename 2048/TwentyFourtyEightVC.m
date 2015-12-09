//
//  TwentyFourtyEightVC.m
//  2048
//
//  Created by Alex Smith on 18/10/2015.
//  Copyright © 2015 Alex Smith. All rights reserved.
//

#import "TwentyFourtyEightVC.h"
#import "TwentyFourtyEight.h"
#import "NoScrollGridVC.h"
#import "TFETile.h"
#import "UILabel+GameTile.h"

@interface TwentyFourtyEightVC () <GridVCDelegate>

@property (strong, nonatomic) NoScrollGridVC *boardCVC;

@property (strong, nonatomic) TwentyFourtyEight *game;

// outlets
@property (weak, nonatomic) IBOutlet UICollectionView *boardView;
@property (weak, nonatomic) IBOutlet UIView *boardContainerView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation TwentyFourtyEightVC

-(NSDictionary *)tileColours
{
    return @{@0 : [UIColor whiteColor],
             @2 : [UIColor yellowColor],
             @4 : [UIColor purpleColor],
             @8 : [UIColor redColor],
             @16 : [UIColor blueColor],
             @32 : [UIColor orangeColor],
             @64 : [UIColor greenColor],
             @128 : [UIColor cyanColor],
             @256 : [UIColor magentaColor],
             @512 : [UIColor brownColor],
             @1024 : [UIColor grayColor]};
}

-(void)newGameWithRows:(int)rows andColumns:(int)cols
{
    [self.game removeObserver:self forKeyPath:@"score"];
    for (id obj in self.boardView.subviews) {
        if ([obj isKindOfClass:[UICollectionViewCell class]]) {
            UICollectionViewCell *cell = (UICollectionViewCell *)obj;
            for (UIView *subview in cell.contentView.subviews) {
                [subview removeFromSuperview];
                NSLog(@"removing");
            }
        }
    }
    self.game = [[TwentyFourtyEight alloc] initWithGameOfSize:(GridSize){rows, cols}];
}

#pragma mark - GridVCDelegate

-(void)swipedInDirection:(UISwipeGestureRecognizerDirection)direction
{
    switch (direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            [self.game swipeInDirection:@"LEFT"];
            break;
        case UISwipeGestureRecognizerDirectionRight:
            [self.game swipeInDirection:@"RIGHT"];
            break;
        case UISwipeGestureRecognizerDirectionUp:
            [self.game swipeInDirection:@"UP"];
            break;
        case UISwipeGestureRecognizerDirectionDown:
            [self.game swipeInDirection:@"DOWN"];
            break;
        default:
            break;
    }
}

#pragma mark - Properties

-(void)setBoardCVC:(NoScrollGridVC *)boardCVC
{
    _boardCVC = boardCVC;
    _boardCVC.delegate = self;
}

-(void)setGame:(TwentyFourtyEight *)game
{
    _game = game;
    
    self.boardCVC = [[NoScrollGridVC alloc] initWithgridSize:self.game.board.size collectionView:self.boardView andCellConfigureBlock:^(UICollectionViewCell *cell, Position position, int index) {
        
        TFETile *currentTile = [self.game.board objectAtPosition:position];
        UILabel *tileLabel;
        
        if ([cell.contentView.subviews count] == 0) {
            tileLabel = [UILabel newGameTileWithFrame:cell.contentView.bounds];
            [cell.contentView addSubview:tileLabel];
        } else {
            tileLabel = [[cell.contentView subviews] firstObject];
        }
        
        tileLabel.text = currentTile.value == 0 ? @"" : [NSString stringWithFormat:@"%d", currentTile.value];
        tileLabel.backgroundColor = [self tileColours][[NSNumber numberWithInt:currentTile.value]];
    
    } andCellTapHandler:NULL];
    
    [self.game addObserver:self forKeyPath:@"score" options:NSKeyValueObservingOptionNew context:nil];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"score"]) {
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
        
        [self.game.board enumerateWithBlock:^(Position position, int index, id obj) {

            TFETile *currentTile = (TFETile *)obj;
            NSIndexPath *currIndexPath = [self.boardCVC indexPathForPosition:position];
            UICollectionViewCell *currCell = [self.boardCVC cellAtPosition:position];
        
            if (currentTile.lastMoveRowOffset != 0 || currentTile.lastMoveColOffset != 0) {
                // make the current tile go blank (if it's a newly generated tile with a non zero value then it will show itself after the animation)
                int currTileValue = currentTile.value;
                currentTile.value = 0;
                [self.boardView reloadItemsAtIndexPaths:@[currIndexPath]];
                currentTile.value = currTileValue;
                
                Position newPos = (Position){position.row + currentTile.lastMoveRowOffset, position.column + currentTile.lastMoveColOffset};
                UICollectionViewCell *newCell = [self.boardCVC cellAtPosition:newPos];
                NSIndexPath *newIndexPath = [self.boardCVC indexPathForPosition:newPos];
                
                UILabel *dummyTileLabel = [UILabel newGameTileWithFrame:currCell.frame];
                dummyTileLabel.text = [NSString stringWithFormat:@"%d", currentTile.previousValue];
                dummyTileLabel.backgroundColor = [self tileColours][[NSNumber numberWithInt:currentTile.previousValue]];
                [self.boardContainerView addSubview:dummyTileLabel];
                
                [UIView animateWithDuration:0.50
                                 animations:^{
                                     dummyTileLabel.frame = newCell.frame;
                                     //dummyTileLabel.alpha = 0.2;
                                 }
                                 completion:^(BOOL finished) {
                                     [UIView performWithoutAnimation:^{
                                        [dummyTileLabel removeFromSuperview];
                                         [self.boardView reloadItemsAtIndexPaths:@[newIndexPath]];
                                     }];
                                     
                }];
            }
            
            if (currentTile.lastMoveNewTile) { // did a newly generated tile appear in the current position during the last turn? if yes then animate this change
                
                UILabel *dummyTileLabel = [UILabel newGameTileWithFrame:currCell.frame];
                dummyTileLabel.text = [NSString stringWithFormat:@"%d", currentTile.value];
                dummyTileLabel.backgroundColor = [self tileColours][[NSNumber numberWithInt:currentTile.value]];
                dummyTileLabel.alpha = 0.0;
                [self.boardContainerView addSubview:dummyTileLabel];
        
                [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    dummyTileLabel.alpha = 1.0;
                } completion:^(BOOL finished) {
                    [UIView performWithoutAnimation:^{
                        [self.boardView reloadItemsAtIndexPaths:@[currIndexPath]];
                        [dummyTileLabel removeFromSuperview];
                    }];
                }];
            }
         }];
    }
}

#pragma mark - View Life Cycle

#define DEFAULT_ROWS 4
#define DEFAULT_COLS 4
-(void)viewDidLoad
{
    [self newGameWithRows:DEFAULT_ROWS andColumns:DEFAULT_COLS];
}

#pragma mark - Action

- (IBAction)newGame:(UIBarButtonItem *)sender
{
    UIAlertController *newGameAlert = [UIAlertController alertControllerWithTitle:@"New Game" message:@"Please select a board size:" preferredStyle:UIAlertControllerStyleAlert];
    
    [newGameAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Board height (4 is default)";
    }];
    
    [newGameAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Board width (4 is default)";
    }];
    
    [newGameAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL]];
    [newGameAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *heightText = [newGameAlert.textFields firstObject].text;
        NSString *widthText = [newGameAlert.textFields firstObject].text;
        int numRows = [heightText intValue];
        int numCols = [widthText intValue];
        [self newGameWithRows:numRows andColumns:numCols];
    }]];
    
    [self presentViewController:newGameAlert animated:YES completion:NULL];
}


@end
