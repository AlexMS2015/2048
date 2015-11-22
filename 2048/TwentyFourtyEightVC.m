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
#import "TileView.h"

@interface TwentyFourtyEightVC () <GridVCDelegate>

@property (strong, nonatomic) NoScrollGridVC *boardCVC;

@property (strong, nonatomic) TwentyFourtyEight *game;
@property (strong, nonatomic) NSDictionary *tileColours;

// outlets
@property (weak, nonatomic) IBOutlet UICollectionView *boardView;
@property (weak, nonatomic) IBOutlet UIView *boardContainerView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end

@implementation TwentyFourtyEightVC

-(void)newGameWithRows:(int)rows andColumns:(int)cols
{
    [self.game removeObserver:self forKeyPath:@"score"];
    for (id obj in self.boardView.subviews) {
        [obj removeFromSuperview];
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

-(NSDictionary *)tileColours
{
    return @{@0 : [UIColor whiteColor],
             @2 : [UIColor grayColor],
             @4 : [UIColor greenColor],
             @8 : [UIColor redColor],
             @16 : [UIColor blueColor],
             @32 : [UIColor orangeColor]};
}

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
        if ([cell.contentView.subviews count] == 0) {
            TileView *tileView = [[TileView alloc] initWithFrame:cell.contentView.bounds];
            tileView.value = currentTile.value;
            [cell.contentView addSubview:tileView];
        } else {
            TileView *cellTileView = [[cell.contentView subviews] firstObject];
            cellTileView.value = currentTile.value;
        }
    } andCellTapHandler:NULL];
    
    [self.game addObserver:self forKeyPath:@"score" options:NSKeyValueObservingOptionNew context:nil];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"score"]) {
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
        
        for (int row = 0; row < self.game.board.size.rows; row++) {
            for (int col = 0; col < self.game.board.size.columns; col++) {
                
                Position position = (Position){row, col};
                TFETile *currentTile = [self.game.board objectAtPosition:position];
                
                if (currentTile.lastMoveRowOffset != 0 || currentTile.lastMoveColOffset != 0) {
                    
                    int currIndex = [self.boardCVC.grid indexOfPosition:position];
                    NSIndexPath *currIndexPath = [NSIndexPath indexPathForItem:currIndex inSection:0];
                    UICollectionViewCell *cell = [self.boardView cellForItemAtIndexPath:currIndexPath];
                    
                    /*UILabel *dummyLabel2 = [[UILabel alloc] initWithFrame:cell.frame];
                    if (!currentTile.lastMoveNewTile) {
                        [self.boardView reloadItemsAtIndexPaths:@[currIndexPath]];
                    } else {
                        dummyLabel2.backgroundColor = [UIColor whiteColor];
                        dummyLabel2.textAlignment = NSTextAlignmentCenter;
                        [self.boardContainerView addSubview:dummyLabel2];
                    }*/
                    
#warning - THIS IS THE PROBLEM WITH NEW CELLS... THEY APPEAR STRAIGHT AWAY... NEED A CONDITIONAL IN HERE
                    [self.boardView reloadItemsAtIndexPaths:@[currIndexPath]];
                    TileView *dummyTileView = [[TileView alloc] initWithFrame:cell.frame];
                    dummyTileView.value = currentTile.lastValue;
                    [self.boardContainerView addSubview:dummyTileView];
                    
                    Position newPos = (Position){position.row + currentTile.lastMoveRowOffset, position.column + currentTile.lastMoveColOffset};
                    int index = [self.boardCVC.grid indexOfPosition:newPos];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
                    CGRect frame = [self.boardView cellForItemAtIndexPath:indexPath].frame;
                    
                    [UIView animateWithDuration:0.50
                                     animations:^{
                                         //dummyLabel.frame = frame;
                                         dummyTileView.frame = frame;
                                     }
                                     completion:^(BOOL finished) {
                                         [UIView animateWithDuration:0 animations:^{
                                            [self.boardView reloadItemsAtIndexPaths:@[indexPath]];
                                         } completion:^(BOOL finished) {
                                             [dummyTileView removeFromSuperview];
                                             /*if (currentTile.lastMoveNewTile) {
                                                 [self.boardView reloadItemsAtIndexPaths:@[currIndexPath]];
                                                 //[dummyLabel2 removeFromSuperview];
                                             }*/
                                         }];
                                     }];
                } else if (currentTile.lastMoveNewTile) {
                    int currIndex = [self.boardCVC.grid indexOfPosition:position];
                    NSIndexPath *currIndexPath = [NSIndexPath indexPathForItem:currIndex inSection:0];
                    [self.boardView reloadItemsAtIndexPaths:@[currIndexPath]];
                    /*[UIView animateWithDuration:1.0
                                     animations:^{
                                         NSLog(@"animating");
                                     } completion:^(BOOL finished) {
                                         [self.boardView reloadItemsAtIndexPaths:@[currIndexPath]];
                                         NSLog(@"done");
                                     }];*/
                }
            }
        }
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
