//
//  Yodo1MASAds.m
//  Created by Yodo1 on 02/25/22.
//
#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <Yodo1MasCore/Yodo1Mas.h>
#import "Yodo1MasBannerAdView.h"
@interface Yodo1MASAds : RCTEventEmitter <RCTBridgeModule,
                                          Yodo1MasRewardDelegate,
                                          Yodo1MasInterstitialDelegate,
                                          Yodo1MasBannerAdDelegate>
@end
@implementation Yodo1MASAds {
  bool hasListeners;
}

- (void)startObserving {
  hasListeners = YES;
}
- (void)stopObserving {
  hasListeners = NO;
}
- (NSArray<NSString *> *)supportedEvents {
  return @[ @"adEvent" ];
}
- (void)sendEvent:(NSString *)event {
  if (hasListeners) {
    [self sendEventWithName:@"adEvent" body:@{@"value" : event}];
    // NSLog(@"Yodo1MASAds: sent Event to RN: %@", event);
  }
}

#pragma mark - Yodo1MasInterstitialDelegate
- (void)onInterstitialAdLoaded:(Yodo1MasInterstitialAd *)ad {
  [self sendEvent:@"interstitial-onInterstitialAdLoaded"];
}

- (void)onInterstitialAdFailedToLoad:(Yodo1MasInterstitialAd *)ad
                           withError:(Yodo1MasError *)error {
  [self sendEvent:@"interstitial-onInterstitialAdFailedToLoad"];
}

- (void)onInterstitialAdOpened:(Yodo1MasInterstitialAd *)ad {
  [self sendEvent:@"interstitial-onInterstitialAdOpened"];
}

- (void)onInterstitialAdFailedToOpen:(Yodo1MasInterstitialAd *)ad
                           withError:(Yodo1MasError *)error {
  [self sendEvent:@"interstitial-onInterstitialAdFailedToOpen"];
  [ad loadAd];
}

- (void)onInterstitialAdClosed:(Yodo1MasInterstitialAd *)ad {
  [self sendEvent:@"interstitial-onInterstitialAdClosed"];
  [ad loadAd];
}

#pragma mark - Yodo1MasRewardDelegate
- (void)onRewardAdLoaded:(Yodo1MasRewardAd *)ad {
  [self sendEvent:@"reward-onRewardAdLoaded"];
}

- (void)onRewardAdFailedToLoad:(Yodo1MasRewardAd *)ad
                     withError:(Yodo1MasError *)error {
  [self sendEvent:@"reward-onRewardAdFailedToLoad"];
}

- (void)onRewardAdOpened:(Yodo1MasRewardAd *)ad {
  [self sendEvent:@"reward-onRewardAdOpened"];
}

- (void)onRewardAdFailedToOpen:(Yodo1MasRewardAd *)ad
                     withError:(Yodo1MasError *)error {
  [self sendEvent:@"reward-onRewardAdFailedToOpen"];
  [ad loadAd];
}

- (void)onRewardAdClosed:(Yodo1MasRewardAd *)ad {
  [self sendEvent:@"reward-onRewardAdClosed"];
  [ad loadAd];
}

- (void)onRewardAdEarned:(Yodo1MasRewardAd *)ad {
  [self sendEvent:@"reward-onRewardAdEarned"];
}
#pragma mark - Yodo1MasAdDelegate
- (void)onAdOpened:(Yodo1MasAdEvent *)event {
  [self sendEvent:@"banner-onAdOpened"];
}

- (void)onAdClosed:(Yodo1MasAdEvent *)event {
  [self sendEvent:@"banner-onAdClosed"];
}

- (void)onAdvertError:(Yodo1MasAdEvent *)event error:(Yodo1MasError *)error {
  [self sendEvent:@"banner-onAdvertError"];
}
/*RCT_EXPORT_METHOD(isInitialized:(RCTPromiseResolveBlock) resolve
rejecter:(RCTPromiseRejectBlock) reject ) { NSLog(@"Yodo1MASAds: isInitialized:
%@", [Yodo1Mas sharedInstance]. ? @"YES" : @"NO"); resolve(@([Yodo1Mas
sharedInstance].initialize));
}*/
RCT_EXPORT_METHOD(initMasSdk) {
  dispatch_async(dispatch_get_main_queue(), ^{
    Yodo1MasAdBuildConfig *config = [Yodo1MasAdBuildConfig instance];
    config.enableUserPrivacyDialog = YES;  // default value is NO
    [[Yodo1Mas sharedInstance] setAdBuildConfig:config];
    [[Yodo1Mas sharedInstance] initWithAppKey:@"r6r4u8L7dM"
        successful:^{
          [self sendEvent:@"onMasInitSuccessful"];
        }
        fail:^(NSError *_Nonnull error) {
          [self sendEvent:@"onMasInitFailed"];
        }];
    // Banner Ad delegate
    [Yodo1Mas sharedInstance].bannerAdDelegate = self;

    // IntertsitialAds Delegate and Load
    [Yodo1MasInterstitialAd sharedInstance].adDelegate = self;
    [[Yodo1MasInterstitialAd sharedInstance] loadAd];

    // Reward Ad loading
    [Yodo1MasRewardAd sharedInstance].adDelegate = self;
    [[Yodo1MasRewardAd sharedInstance] loadAd];
  });
}
RCT_EXPORT_METHOD(showRewardedAds) {
  dispatch_async(dispatch_get_main_queue(), ^{
    [[Yodo1MasRewardAd sharedInstance]
        showAdWithPlacement:@"Your Placement Id"];
  });
}
RCT_EXPORT_METHOD(showIntertstialAds) {
  dispatch_async(dispatch_get_main_queue(), ^{
    [[Yodo1MasInterstitialAd sharedInstance]
        showAdWithPlacement:@"Your Placement"];
  });
}
RCT_EXPORT_METHOD(showBannerAds) {
  dispatch_async(dispatch_get_main_queue(), ^{
    Yodo1MasAdBannerAlign align =
        Yodo1MasAdBannerAlignBottom | Yodo1MasAdBannerAlignHorizontalCenter;
    CGPoint point = CGPointMake(10.0f, 10.0f);
    [[Yodo1Mas sharedInstance] showBannerAdWithAlign:align offset:point];
  });
}
RCT_EXPORT_METHOD(hideBannerAds) {
  dispatch_async(dispatch_get_main_queue(), ^{
    [[Yodo1Mas sharedInstance] dismissBannerAd];

    BOOL destroy = NO;  // if destroy == YES, the ads displayed in the next call
                        // of showBanner are different. if destroy == NO, the
                        // ads displayed in the next call of showBanner are the same
    [[Yodo1Mas sharedInstance] dismissBannerAdWithDestroy:destroy];
  });
}
// To export a module named Yodo1MASAds
RCT_EXPORT_MODULE(Yodo1MASAds);
@end