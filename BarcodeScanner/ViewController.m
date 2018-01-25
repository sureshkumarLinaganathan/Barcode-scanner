//
//  ViewController.m
//  BarcodeScanner
//
//  Created by Sureshkumar Linganathan on 10/03/17.
//  Copyright © 2017 Impiger Technologies. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewPlayer;
@property (weak, nonatomic) IBOutlet UIView *barcodeView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        [self setupView];
    }
    [_session startRunning];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

-(void)setupView
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    self.session = [[AVCaptureSession alloc]init];
    if(deviceInput){
    [_session addInput:deviceInput];
    AVCaptureMetadataOutput *captureOutput = [[AVCaptureMetadataOutput alloc]init];
    captureOutput.rectOfInterest = CGRectMake(0, 0.1, 1, 1);
    [self.session addOutput:captureOutput];
    [captureOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    NSArray *barCodeTypes = [[NSArray alloc]initWithObjects:AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeDataMatrixCode, nil];
    [captureOutput setMetadataObjectTypes:barCodeTypes];
    _previewPlayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    [_previewPlayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_previewPlayer setFrame:self.barcodeView.frame];
    [self.view.layer addSublayer:_previewPlayer];
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection;
{
    if((metadataObjects == nil)||([metadataObjects count]==0))
    {
        printf("no barcode detect");
        return;
    }
    AVMetadataMachineReadableCodeObject *object = [metadataObjects objectAtIndex:0];
    NSLog(@"%@",object.type);
    NSLog(@"%@",object.stringValue);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
