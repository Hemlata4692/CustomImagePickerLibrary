//
//  CameraViewController.m
//  CustomImagePickerLibrary
//
//  Created by Hema on 05/05/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

#import "CameraViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImagePicker.h"

#define kCellsPerRow 3

@interface CameraViewController ()<ImagePickerDelegate>
{
    NSMutableArray *assetsImagesArray, *selectedArrayCount;
    ImagePicker *objcImagePicker;
    int maximumCount;
}
@property (weak, nonatomic) IBOutlet UILabel *selectionLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *imagePickercollectionView;
@end

@implementation CameraViewController
@synthesize imagePickercollectionView;
@synthesize selectionLabel;

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"Camera Roll";
    
    selectedArrayCount=[[NSMutableArray alloc]init];
    assetsImagesArray = [[NSMutableArray alloc] init];
    
    selectionLabel.hidden=YES;
    
    //allow multiple selection
    [imagePickercollectionView setAllowsMultipleSelection:YES];
    //set maximun number of image selection
    maximumCount=12;
    
    //image picker set delgate
    objcImagePicker = [ImagePicker new];
    objcImagePicker.delegate = self;
    //get images from assest library
    [objcImagePicker uiImagePickerLoader];
    
    //set 3 images in one row in collection view
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)imagePickercollectionView.collectionViewLayout;
    CGFloat availableWidthForCells = CGRectGetWidth(self.view.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow-1);
    CGFloat cellWidth = (availableWidthForCells / kCellsPerRow);
    flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden=NO;
}
#pragma mark - end

#pragma mark - Image picker delegate method
//load images from assets
-(void)loadImages:(NSMutableArray *)assestValue{
    assetsImagesArray = [assestValue mutableCopy];
    [imagePickercollectionView reloadData];
}
#pragma mark - end

#pragma mark - Collection view datasource delgate methods
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return assetsImagesArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    UIImageView *savedImage = (UIImageView*)[cell viewWithTag:1];
    UIImageView *selectedImage = (UIImageView*)[cell viewWithTag:2];
    if (cell.selected==YES) {
        selectedImage.hidden=NO;
    }
    else {
        selectedImage.hidden=YES;
    }
    
    ALAsset *asset = (ALAsset *)assetsImagesArray[indexPath.row];
    //gisplay thumbnail images on cell
    savedImage.image=[UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
    //load full resolution images
    //savedImage.image=[self imageForAsset:asset];
    return cell;
}

//full resolution images
-(UIImage*) imageForAsset:(ALAsset*) aAsset{
    ALAssetRepresentation *rep;
    rep = [aAsset defaultRepresentation];
    return [UIImage imageWithCGImage:[rep fullScreenImage]];
    //    return [UIImage imageWithCGImage:[rep fullResolutionImage]];
}
//end

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedArrayCount.count<maximumCount) {
        UICollectionViewCell *selectedCell =[collectionView cellForItemAtIndexPath:indexPath];
        UIImageView *selectedImage = (UIImageView*)[selectedCell viewWithTag:2];
        selectedImage.hidden=NO;
        // Determine the selected items by using the indexPath
        UIImage *selectedRecipe = [assetsImagesArray objectAtIndex:indexPath.row];
        // Add the selected item into the array
        [selectedArrayCount addObject:selectedRecipe];
        if (selectedArrayCount.count==0) {
            selectionLabel.hidden=YES;
        }
        else if (selectedArrayCount.count==1){
            selectionLabel.hidden=NO;
            selectionLabel.text=[NSString stringWithFormat:@"%d photo selected",(int)selectedArrayCount.count];
        }
        else {
            selectionLabel.hidden=NO;
            selectionLabel.text=[NSString stringWithFormat:@"%d photos selected",(int)selectedArrayCount.count];
        }
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
        //show toast
        NSString *message = [NSString stringWithFormat:@"You can select a maximum of %d images.",maximumCount];
        UIAlertController * toast = [UIAlertController
                                     alertControllerWithTitle:nil
                                     message:message
                                     preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:toast animated:YES completion:nil];
        int duration = 2; // duration in seconds
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{                [toast dismissViewControllerAnimated:YES completion:nil];
        });
            });
    }
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *selectedCell =[collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *selectedImage = (UIImageView*)[selectedCell viewWithTag:2];
    selectedImage.hidden=YES;
    UIImage *selectedRecipe = [assetsImagesArray objectAtIndex:indexPath.row];
    // Add the selected item into the array
    [selectedArrayCount removeObject:selectedRecipe];
    if (selectedArrayCount.count==0) {
        selectionLabel.hidden=YES;
    }
    else if (selectedArrayCount.count==1){
        selectionLabel.hidden=NO;
        selectionLabel.text=[NSString stringWithFormat:@"%d photo selected",(int)selectedArrayCount.count];
    }
    else {
        selectionLabel.hidden=NO;
        selectionLabel.text=[NSString stringWithFormat:@"%d photos selected",(int)selectedArrayCount.count];
    }
    if (selectedArrayCount.count==0) {
        imagePickercollectionView.allowsSelection=YES;
    }
}
#pragma mark - end

@end
