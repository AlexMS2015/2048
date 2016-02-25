//
//  TwentyFourtyEightVC.m
//  2048
//
//  Created by Alex Smith on 18/10/2015.
//  Copyright © 2015 Alex Smith. All rights reserved.
//

#import "TwentyFourtyEightVC.h"
#import "TwentyFourtyEight.h"
#import "TFETile.h"
#import "UILabel+GameTile.h"
#import "CollectionViewDataSource.h"
#import "UICollectionViewFlowLayout+GridLayout.h"
#import "ViewSwipeGestureHandler.h"

@interface TwentyFourtyEightVC () <ViewSwipeGestureHandlerDelegate>

@property (strong, nonatomic) TwentyFourtyEight *game;

// external helper objects
@property (strong, nonatomic) CollectionViewDataSource *boardDataSource;
@property (strong, nonatomic) ViewSwipeGestureHandler *boardSwipeGestureHandler;

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
    self.game = [[TwentyFourtyEight alloc] initWithRows:rows andColumns:cols];
}

#pragma mark - GridVCDelegate

-(void)view:(UIView *)view swipedInDirection:(UISwipeGestureRecognizerDirection)direction
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

-(void)setBoardView:(UICollectionView *)boardView
{
    _boardView = boardView;
}

-(void)setGame:(TwentyFourtyEight *)game
{
    _game = game;
    
    static NSString * const CVC_IDENTIFIER = @"CollectionViewCell";
    [self.boardView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CVC_IDENTIFIER];
    
    self.boardDataSource = [[CollectionViewDataSource alloc] initWithSections:self.game.board.numRows itemsPerSection:self.game.board.numCols cellIdentifier:CVC_IDENTIFIER cellConfigureBlock:^(NSInteger section, NSInteger item, UICollectionViewCell *cell) {
        
        TFETile *currentTile = self.game.board.objects[section][item];
        
        UILabel *tileLabel = [UILabel newGameTileWithFrame:cell.contentView.bounds];
        tileLabel.text = currentTile.value == 0 ? @"" : [NSString stringWithFormat:@"%d", currentTile.value];
        tileLabel.backgroundColor = [self tileColours][[NSNumber numberWithInt:currentTile.value]];
        
        cell.backgroundView = tileLabel;
    }];
    self.boardView.dataSource = self.boardDataSource;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.boardView.collectionViewLayout;
    [layout layoutAsGrid];
    
    self.boardSwipeGestureHandler = [[ViewSwipeGestureHandler alloc] initWithView:self.boardView];
    self.boardSwipeGestureHandler.delegate = self;
    
    [self.game addObserver:self forKeyPath:@"score" options:NSKeyValueObservingOptionNew context:nil];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"score"]) { // the score changing means a turn has been played
        
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
        
        [self.game.board enumerateWithBlock:^(Position position, id obj) {
            
            TFETile *currentTile = (TFETile *)obj;
            
            NSIndexPath *currIndexPath = [NSIndexPath indexPathForItem:position.column
                                                             inSection:position.row];
            UICollectionViewCell *currCell = [self.boardView cellForItemAtIndexPath:currIndexPath];
            
            if (currentTile.lastMoveRowOffset != 0 || currentTile.lastMoveColOffset != 0) {
                // make the current tile go blank (if a new non-zero tile has also been generated in this position then it will show after the following animation)
                int currTileValueTemp = currentTile.value;
                currentTile.value = 0;
                [self.boardView reloadItemsAtIndexPaths:@[currIndexPath]];
                currentTile.value = currTileValueTemp;
                
                Position newPos = (Position){position.row + currentTile.lastMoveRowOffset, position.column + currentTile.lastMoveColOffset};
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:newPos.column
                                                                inSection:newPos.row];
                UICollectionViewCell *newCell = [self.boardView cellForItemAtIndexPath:newIndexPath];
                
                // generate a fake tile to be animated at the current position
                UILabel *dummyTileLabel = [UILabel newGameTileWithFrame:currCell.frame];
                dummyTileLabel.text = [NSString stringWithFormat:@"%d", currentTile.previousValue];
                dummyTileLabel.backgroundColor = [self tileColours][[NSNumber numberWithInt:currentTile.previousValue]];
                [self.boardContainerView addSubview:dummyTileLabel];
                
                [UIView animateWithDuration:0.50
                                 animations:^{
                                     dummyTileLabel.frame = newCell.frame;
                                 }
                                 completion:^(BOOL finished) {
                                     [UIView performWithoutAnimation:^{
                                         [dummyTileLabel removeFromSuperview];
                                         [self.boardView reloadItemsAtIndexPaths:@[newIndexPath]];
                                     }];
                                     
                                 }];
            }
            
            if (currentTile.lastMoveNewTile) { // did a newly generated tile appear in the current position during the last turn? if yes, then animate this change with a dummy tile
                
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
        NSString *widthText = [newGameAlert.textFields lastObject].text;
        int numRows = [heightText intValue];
        int numCols = [widthText intValue];
        [self newGameWithRows:numRows andColumns:numCols];
    }]];
    
    [self presentViewController:newGameAlert animated:YES completion:NULL];
}


@end