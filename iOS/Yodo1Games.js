import {Alert, NativeEventEmitter, NativeModules} from 'react-native'

const {Yodo1MASAds} = NativeModules
export const hasReward =
    () => {
      // Your code here to check if the user has earned a reward
      // From Redux, AsyncStorage
      return true
    } export const setReward =
        () => {
          // Your code here to confirm that the user earned a reward
          // Redux, AsyncStorage, etc...
        } export const isAdsInitialized =
            () => {
              // Your code here to check if the ads are initialized from other
              // components
            } export const setAdsInitialized =
                (isInitialized) => {
                  // Your code here to set the adsInitialized state
                  // Redux, AsyncStorage, etc...
                } export const showAdExplainer = () =>
                    Alert.alert(
                        'You must watch the entire Ad to earn the reward!')
export const ShowRewardGivenAlert = () => Alert.alert('Reward Added')
const handleYodoEvent =
    ({value}) => {
      __DEV__ && console.log(`MAS Event: ${value}`)
      switch (value) {
        // Event received when Ads initialization is successful
        case 'onMasInitSuccessful':
          Yodo1MASAds.showBannerAds()  // This has effect only on Android
          // setAdsInitialized(true)
          // isAdsInitialized(true);
          break case 'onMasInitFailed': setTimeout(
              () => Yodo1MASAds.initMasSdk(), 5000)  // Try again in 5 seconds
          break
              // User earned a reward!
              case 'reward-onRewardAdEarned': setTimeout(
                  () => hasReward() ? null : ShowRewardGivenAlert(), 5000)
          setReward()
          break
              // Reward Ad loaded, you can check by this method if the ad is
              // loaded
              case 'reward-onRewardAdLoaded':
                  setTimeout(() => hasReward() ? null : showAdExplainer(), 500)
          break
              // Reward Ad Failed to Open
              case 'reward-onRewardAdOpened':
                  setTimeout(() => hasReward() ? null : showAdExplainer(), 500)
          break
              // User closed the Ad, let's check if he earned a reward
              case 'reward-onRewardAdClosed':
                  setTimeout(() => hasReward() ? null : showAdExplainer(), 500)
          break
              // Something went wrong, let's skip the checks on reward
              case 'reward-onRewardAdFailedToLoad':
                  // setReward()
              break
      }
    }
// Call me on App Initialization
export const registerYodoAds = () => {
  const eventEmitter = new NativeEventEmitter(Yodo1MASAds)
  const eventListener = eventEmitter.addListener('adEvent', handleYodoEvent)
  Yodo1MASAds.initMasSdk()
  return eventListener
} export const showBannerAds = async () => {
  // const adsAvailable = await Yodo1MASAds.isInitialized()
  // adsAvailable &&
  Yodo1MASAds.showBannerAds()
} export const dismissBannerAds = async () => {
  // const adsAvailable = await Yodo1MASAds.isInitialized()
  // adsAvailable &&
  Yodo1MASAds.hideBannerAds()
} export const showInterstitialAds = async () => {
  // const adsAvailable = await Yodo1MASAds.isInitialized()
  // adsAvailable &&
  Yodo1MASAds.showIntertstialAds()
} export const showRewardedAds = async () => {
  // const adsAvailable = await Yodo1MASAds.isInitialized()
  // adsAvailable ?
  Yodo1MASAds.showRewardedAds()  //: setReward()
}