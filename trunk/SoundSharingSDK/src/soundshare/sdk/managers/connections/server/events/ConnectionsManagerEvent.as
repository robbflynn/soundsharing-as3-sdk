package soundshare.sdk.managers.connections.server.events
{
	import flashsocket.client.managers.events.events.ClientEventDispatcherEvent;
	
	public class ConnectionsManagerEvent extends ClientEventDispatcherEvent
	{
		public static const WATCH_FOR_DISCONNECT_COMPLETE:String = "WATCH_FOR_DISCONNECT_COMPLETE";
		public static const WATCH_FOR_DISCONNECT_ERROR:String = "WATCH_FOR_DISCONNECT_ERROR";
		
		public static const DISCONNECT_DETECTED:String = "DISCONNECT_DETECTED";
		
		public function ConnectionsManagerEvent(type:String, data:Object = null, body:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, body, bubbles, cancelable);
		}
	}
}