# vast4-adverification
Draft of an interface for the VAST 4.0 AdVerification script by Meetrics GmbH.
The VAST 4.0 specification describes a new AdVerification xml node that can contain JavaScript or ActionScript (Flash) resources. The specification only states that the node contains an apiFramework attribute that identifies the API that is needed to execute the AdVerification code. The specification does not state what the valid apiFrameworks are. The specification can be found [here](http://www.iab.com/wp-content/uploads/2016/04/VAST4.0_Updated_April_2016.pdf).
This repository is a draft of a possible apiFramework.
##VAST4 AdVerification Interface
The workflow if using this interface would look like this:
The player needs to parse the VAST file. If it finds an AdVerification node it should execute the following steps:
1. In case of JavaScriptResource:
- Write a same site iframe into the document and inject the AdVerification JavaScriptResource
```
  iframe = document.createElement('iframe');
  iframe.id = "adverificationloaderframe";
  document.body.appendChild(iframe);
  // url contains content of JavaScriptResource node
  iframe.contentWindow.document.write('<script src="' + url + '"></scr' + 'ipt>');
  var onLoaded = function() {
    var adVerification;
    var fn = iframe.contentWindow['getAdVerification'];
    if (fn && typeof fn == 'function') {
      adVerification = fn();
    }
    else {
      setTimeout(onLoaded, 100);
      return;
    }
    // use adVerification to access the adVerification adapter
  }
  setTimeout(onLoaded, 10);
```
- You can register event handlers on the AdVerification adapter. There are the following events: AdVerificationLoaded, AdVerificationStarted, AdVerificationStopped, AdVerificationError, AdVerificationLog, (optional: AdVerificationViewableImpression). The event handler is registered like this:
```
adVerification.subscribe(handler, "AdVerificationLoaded");
```
- Once the AdVerification adapter interface is available you need to call initAd() method. This method takes the same parameters as the initAd() method of a VPAID ad. So in case of a VPAID ad you can just call initAd() of the AdVerification adapter directly after calling it on the VPAID ad passing the same parameters. In case of non-VPAID ad (video mediafile) you can call it like this:
```
adVerification.initAd(width, height, "normal", 800, {AdParameters: ''}, {slot: containerDiv, videoSlot: videoElement});
```
- The AdVerification adapter will fire the AdVerificationLoaded event once initAd finishes successfully. The player should then call initEventsWiring() to allow the AdVerification adapter to subscribe to all events it needs.
```
adVerification.initEventsWiring(eventDispatcher);
```
The eventDispatcher parameter should support the following methods: subscribe, unsubscribe, getAdVolume, getAdRemainingTime. In case of a VPAID you can just pass the VPAID ad as eventDispatcher.
- If the measurement was set up correctly the AdVerification adapter will fire the AdVerificationStarted event. If/when the ad becomes viewable (because it reaches the 50% area and 2 seconds time threshold) the AdVerification adapter may fire the (optional) AdVerificationViewableImpression event. This will allow players to easily support the ViewableImpression xml node (it then can fire tracking pixels on receiving this event). There needs to be some common understanding of publisher and advertiser on whether the AdVerification adapter supports this event.
- When the ad has finished playing, the player should call dispose(). The AdVerification adapter will then dispose of all resources and finish the measurement (if it has not done before on some ad event).
```
adVerification.dispose();
```
When this is done, the AdVerification adapter will fire the AdVerificationStopped event.
2. In case of ActionScriptResource (flash):
- The general workflow is the same as for the JavaScriptResource. The AdVerification adapter should be a swf file that is loaded directly by the player. The creativeData and environmentVars parameters of initAd() can be empty Strings. Events can be subscribed to using addEventListener() on adVerification.
