package de.meetrics{

        import flash.events.Event;

        public class AdVerificationEvent extends Event
        {

                public static const AdVerificationLoaded                        : String = "AdVerificationLoaded";
                public static const AdVerificationError                         : String = "AdVerificationError";
                public static const AdVerificationLog                           : String = "AdVerificationLog";
                public static const AdVerificationViewableImpression            : String = "AdVerificationViewableImpression";
                public static const AdVerificationStarted                       : String = "AdVerificationStarted";
                public static const AdVerificationStopped                       : String = "AdVerificationStopped";

                private var _data                                                       :Object;


                public function AdVerificationEvent( type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false )
                {
                        super(type, bubbles, cancelable);
                        _data = data;

                }

                public function get data():Object
                {
                        return _data;
                }

                override public function clone():Event
                {
                        return new AdVerificationEvent( type, _data, bubbles, cancelable );
                }

        }

}
