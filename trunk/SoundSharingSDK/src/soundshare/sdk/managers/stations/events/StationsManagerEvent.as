package soundshare.sdk.managers.stations.events
{
	import flash.events.Event;
	
	import flashsocket.client.managers.events.events.ClientEventDispatcherEvent;
	
	public class StationsManagerEvent extends ClientEventDispatcherEvent
	{
		
		public static const STATION_UP_COMPLETE:String = "STATION_UP_COMPLETE";
		public static const STATION_UP_ERROR:String = "STATION_UP_ERROR";
		
		public static const STATION_DOWN_COMPLETE:String = "STATION_DOWN_COMPLETE";
		public static const STATION_DOWN_ERROR:String = "STATION_DOWN_ERROR";
		
		public static const STATION_UP_DETECTED:String = "STATION_UP_DETECTED";
		public static const STATION_DOWN_DETECTED:String = "STATION_DOWN_DETECTED";
		
		public static const START_WATCH_COMPLETE:String = "START_WATCH_COMPLETE";
		public static const START_WATCH_ERROR:String = "START_WATCH_ERROR";
		
		public function StationsManagerEvent(type:String, data:Object = null, body:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, body, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new StationsManagerEvent(type, data, body, bubbles, cancelable);
		}
	}
}