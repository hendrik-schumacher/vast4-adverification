package de.meetrics {
	
	import flash.events.IEventDispatcher;

        /**
         * The AdVerificationLog event is optionally sent by the ad verification adapter to the player to relay debugging
         * information, in a parameter String message.
         */
        [Event(name="AdVerificationLog", type="de.meetrics.AdVerificationEvent")]

        /**
         * The AdVerificationError event is sent when the ad verification adapter has experienced a fatal error. Before the ad
         * verification adapter sends AdVerificationError it must clean up all resources.
         */
        [Event(name="AdVerificationError", type="de.meetrics.AdVerificationEvent")]

        /**
         * The AdVerificationViewableImpression event is used to notify the player that the ad has reached the threshold for
         * a viewable impression. The player can then invoke any ViewabileImpression pixels.
         */
        [Event(name="AdVerificationViewableImpression", type="de.meetrics.AdVerificationEvent")]

        /**
         * The AdVerificationStarted event is used to notify the player that the ad verification adapter has finished setup and
         * started working. The adapter should dispatch it when the player calls initEventsWiring().
         */
        [Event(name="AdVerificationStarted", type="de.meetrics.AdVerificationEvent")]

        /**
         * The AdVerificationStopped event is used to notify the player that the ad verification adapter has finished working.
         * The adapter should dispatch it when the player calls dispatch().
         */
        [Event(name="AdVerificationStopped", type="de.meetrics.AdVerificationEvent")]

	/**
	 * IAdVerification interface for OVP players.
	 *
	 */
	public interface IAdVerification extends IEventDispatcher
	{
		// Methods
		
		/**
		 * The player calls handshakeVersion immediately after loading the AdVerification adapter to indicate to the
		 * ad which version of VAST will be used. The player passes in its latest VAST version string. The adapter
		 * returns a version string minimally set to "4.0.0", and of the form "major.minor.patch".
		 * The player must verify that it supports the particular version of VAST or cancel using the adapter.
		 */
		function handshakeVersion(playerVASTVersion : String) : String;
		
		/**
		 * After the ad is loaded and the player calls handshakeVersion, the player calls initAd to
		 * initialize the adapter. For VPAID ads this call should be done directly after calling initAd
		 * on the VPAID ad. In case of mediafile playback the call to initAd should be done after parsing
		 * of the VAST has been completed.
                 * If everything was successfully initialized, the adapter will dispatch an AdVerificationLoaded event, otherwise
                 * an AdVerificationError event.
		 */ 
		function initAd(width : Number, height : Number, viewMode : String, desiredBitrate : Number, creativeData : String, environmentVars : String) : void;
		
		/**
		 * initEventsWiring is called by the player to allow the adapter to register event handlers for all
                 * required events. The player should pass in an EventDispatcher. This could be the VPAID ad in VPAID cases.
                 * The EventDispatcher should also support getters for adVolume and adRemainingTime (as specified in IVPAID).
                 * This method can be called when the player receives the AdVerificationLoaded event.
                 * If method is successful, it will dispatch AdVerificationStarted, otherwise AdVerificationError.
		 */ 
		function initEventsWiring(eventDispatcher: Object) : void;
		
		/**
		 * dispose is called by the player when the player finished displaying the ad.
                 * This method will dispatch AdVerificationStopped when finished.
		 */
		function dispose() : void;

                /**
                 * signalViewableImpression should be used by the AdVerification implementation to tell the adapter to
                 * dispatch an AdVerificationViewableImpression event.
		 */
                function signalViewableImpression() : void;

	}
}
