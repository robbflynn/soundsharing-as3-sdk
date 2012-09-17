package soundshare.sdk.managers.channels.events
{
	import flashsocket.client.managers.events.events.ClientEventDispatcherEvent;
	
	public class ChannelsManagerEvent extends ClientEventDispatcherEvent
	{
		public static const CHANNEL_ACTIVATION_DETECTED:String = "CHANNEL_ACTIVATION_DETECTED";
		public static const CHANNEL_DEACTIVATION_DETECTED:String = "CHANNEL_DEACTIVATION_DETECTED";
		
		public static const START_WATCH_COMPLETE:String = "START_WATCH_COMPLETE";
		public static const START_WATCH_ERROR:String = "START_WATCH_ERROR";
		
		public function ChannelsManagerEvent(type:String, data:Object = null, body:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, body, bubbles, cancelable);
		}
	}
}