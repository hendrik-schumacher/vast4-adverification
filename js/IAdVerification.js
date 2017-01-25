"use strict";
var IAdVerification = function() {
	this.log = MeetricsAdVerification.prototype.utils.log;
	this.conf = MeetricsAdVerification.prototype.model.config;
};

/**
* Initializes the ad verification adapter. Parameters are the same as for the initAd call on Vpaid ad.
* @param {number} width.
* @param {number} height.
* @param {string} viewMode.
* @param {number} desiredBitrate.
* @param {Object} creativeData.
* @param {Object} environmentVars.
*/
IAdVerification.prototype.initAd = function(width, height, viewMode, desiredBitrate, creativeData, environmentVars) {
	this.log.out("IAdVerification", "player call initAd", "#663300");
	MeetricsAdVerification.prototype.initAd(width, height, viewMode, desiredBitrate, creativeData, environmentVars, this);
};

/**
* Tells the ad verification adapter to set up event listeners for all needed events on the given event dispatcher.
* The eventDispatcher object has to support the following methods: subscribe(), getAdVolume() and getAdRemainingTime().
* @param {Object} eventDispatcher Object the player can use to get events and information from.
*/
IAdVerification.prototype.initEventsWiring = function(eventDispatcher) {
	this.log.out("IAdVerification", "player call initEventsWiring", "#663300");
	MeetricsAdVerification.prototype.initEventsWiring(eventDispatcher);
};

/**
* Tells the ad verification adapter to stop measuring and to dispose all resources.
*/
IAdVerification.prototype.dispose = function() {
	this.log.out("IAdVerification", "player call dispose", "#663300");
	MeetricsAdVerification.prototype.dispose();
};

/**
* Does a version handshake.
* @param {string} version The player version.
* @return {string} The ad verification adapter version.
*/
IAdVerification.prototype.handshakeVersion = function(version) {
	this.log.out("IAdVerification", "player call handshakeVersion version: " + version, "#663300");
	return this.conf.HANDSHAKE_VERSION;
};

/**
* External resources should use this function to tell the ad verification adapter that the impression reached the
* viewable impression threshold (50% of the area for at least 2 seconds).
*/
IAdVerification.prototype.signalViewableImpression = function() {
        this.log.out("IAdVerification", "received viewable impression signal", "#663300");
        MeetricsAdVerification.prototype.fireAdVerificationEvent("AdVerificationViewableImpression");
};

//********************************************************************************
//******************************** EVENT LISTENER ********************************
//********************************************************************************

/**
* Registers a callback for an event.
* @param {Function} aCallback The callback function.
* @param {string} eventName The callback type.
* @param {Object} aContext The context for the callback.
*/
IAdVerification.prototype.subscribe = function(aCallback, eventName, aContext) {
        this.log.out("IAdVerification", "player subscribe: " + eventName, "#663300");
        if (aContext) {
                this.conf.playerEventsCallback[eventName] = aCallback.bind(aContext);
        }
        else {
                this.conf.playerEventsCallback[eventName] = aCallback;
        }
};

/**
* Removes a callback based on the eventName.
* @param {string} eventName The callback type.
*/
IAdVerification.prototype.unsubscribe = function(eventName) {
        this.log.out("IAdVerification", "player unsubscribe: " + eventName, "#663300");
        this.conf.playerEventsCallback[eventName] = null;
};

/**
 * Main function called by player to get the ad verification adapter.
 * @return {Object} The ad verification adapter.
 */
 window.getAdVerification = function() {
	return new IAdVerification();
};
