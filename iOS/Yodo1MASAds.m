//
//  Yodo1MASAds.m
//  Created by Yodo1 on 02/25/22.
//
 
#import <Foundation/Foundation.h>
#import <Yodo1MasCore/Yodo1Mas.h>
#import <React/RCTEventEmitter.h>
#import <React/RCTBridgeModule.h>
 
@interface Yodo1MASAds: RCTEventEmitter <RCTBridgeModule, Yodo1MasRewardAdDelegate, Yodo1MasInterstitialAdDelegate, Yodo1MasBannerAdDelegate>
@end
 
@implementation Yodo1MASAds
{
  bool hasListeners;
}
 
-(void)startObserving {
  hasListeners = YES;
}
 
-(void)stopObserving {
  hasListeners = NO;
}
 
- (NSArray<NSString *> *)supportedEvents {
  return @[@"adEvent"];
}
 
- (void) sendEvent:(NSString *) event {
  if (hasListeners) {
    [self sendEventWithName:@"adEvent" body:@{@"value": event}];
    NSLog(@"Yodo1MASAds: sent Event to RN: %@", event);
  }
}
 
- (void)onAdOpened:(Yodo1MasAdEvent *)event {
  [self sendEvent:@"reward-onAdOpened"];
}
 
- (void)onAdClosed:(Yodo1MasAdEvent *)event {
  [self sendEvent:@"reward-onAdClosed"];
}
 
- (void)onAdError:(Yodo1MasAdEvent *)event error:(Yodo1MasError *)error {
  switch (event.type) {
    case Yodo1MasAdTypeReward: {
      [self sendEvent:@"reward-onAdError"];
      break;
    }
    case Yodo1MasAdTypeInterstitial: {
      [self sendEvent:@"interstitial-onAdError"];
      break;
    }
    case Yodo1MasAdTypeBanner: {
      [self sendEvent:@"banner-onAdError"];
      break;
    }
  }
}
 
- (void)onAdRewardEarned:(Yodo1MasAdEvent *)event {
  [self sendEvent:@"reward-onAdvertRewardEarned"];
}
 
/*RCT_EXPORT_METHOD(isInitialized:(RCTPromiseResolveBlock) resolve rejecter:(RCTPromiseRejectBlock) reject ) {
  NSLog(@"Yodo1MASAds: isInitialized: %@", [Yodo1Mas sharedInstance]. ? @"YES" : @"NO");
  resolve(@([Yodo1Mas sharedInstance].initialize));
}*/
 
RCT_EXPORT_METHOD(initMasSdk) {
  dispatch_async(dispatch_get_main_queue(), ^{
    [Yodo1Mas sharedInstance].rewardAdDelegate = self;
    [Yodo1Mas sharedInstance].interstitialAdDelegate = self;
    
    Yodo1MasAdBuildConfig *config = [Yodo1MasAdBuildConfig instance];
    config.enableAdaptiveBanner = YES;
    config.enableUserPrivacyDialog = YES;
    [[Yodo1Mas sharedInstance] setAdBuildConfig:config];
 
    [[Yodo1Mas sharedInstance] initWithAppKey:@"r6r4u8L7dM" successful:^{
      [self sendEvent:@"onMasInitSuccessful"];
    } fail:^(NSError * _Nonnull error) {
      [self sendEvent:@"onMasInitFailed"];
    }];
  });
}
 
RCT_EXPORT_METHOD(showRewardedAds) {
  dispatch_async(dispatch_get_main_queue(), ^{
    [[Yodo1Mas sharedInstance] showRewardAd];
  });
}
 
RCT_EXPORT_METHOD(showIntertstialAds) {
  dispatch_async(dispatch_get_main_queue(), ^{
    [[Yodo1Mas sharedInstance] showInterstitialAd];
  });
}
 
RCT_EXPORT_METHOD(showBannerAds) {
 dispatch_async(dispatch_get_main_queue(), ^{
    Yodo1MasAdBannerAlign align = Yodo1MasAdBannerAlignBottom | Yodo1MasAdBannerAlignHorizontalCenter;
    CGPoint point = CGPointMake(10.0f, 10.0f);
    [[Yodo1Mas sharedInstance] showBannerAdWithAlign:align offset:point];
  });
}

// To export a module named Yodo1MASAds
RCT_EXPORT_MODULE(Yodo1MASAds);
@end