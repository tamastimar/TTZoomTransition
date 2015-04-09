# TTZoomTransition

[![Travis](https://img.shields.io/travis/tamastimar/TTZoomTransition.svg)]()
[![Coveralls](https://img.shields.io/coveralls/tamastimar/TTZoomTransition.svg)]()

**`TTZoomTransition` is a custom modal view controller transition which displays the presented view controller by zoom animation.**

![TTZoomTransition in action](https://raw.githubusercontent.com/tamastimar/TTZoomTransition/assets/ttzoomtransition-screenshot.gif)

## Installation

You can use `TTZoomTransition` via [CocoaPods](http://cocoapods.org). Add the following line to your `Podfile`:

#### Podfile

```ruby
pod TTZoomTransition
```

## Usage

Set `modalPresentationStyle` property of your modal view controller to `UIModalPresentationCustom`. Also set the  `transitioningDelegate` property. 

``` objective-c
ModalViewController* modalVC = [[ModalViewController alloc] init];
modalVC.modalPresentationStyle = UIModalPresentationCustom;
modalVC.transitioningDelegate = self;

[self presentViewController:modalVC animated:YES completion:nil];
```

In your transitioning delegate implement the following methods of `UIViewControllerTransitioningDelegate`:

``` objective-c
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    TTZoomTranstition* zoomTransition = [[TTZoomTranstition alloc] init];
    return zoomTransition;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    TTZoomTranstition* zoomTransition = [[TTZoomTranstition alloc] init];
    zoomTransition.presenting = NO;
    return zoomTransition;
}
```

## Demo

```bash
pod try TTZoomTransition
```

If you don't have [CocoaPods](http://cocoapods.org) on your machine, get it: `[sudo] gem install cocoapods`.

## Requirements

- iOS 7+

## Contact

Tamás Tímár

- https://tamastimar.com
- https://github.com/tamastimar

## License

`TTZoomTransition` is available under the [MIT license](https://choosealicense.com/licenses/mit/). See the LICENSE file for more info.

## Acknowledgements
Images in example are from [Pixabay](http://pixabay.com).
