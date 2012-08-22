package soundshare.sdk.managers.servers.events
{
	import socket.client.managers.events.events.ClientEventDispatcherEvent;
	
	public class ServersManagerEvent extends ClientEventDispatcherEvent
	{
		public static const SERVER_UP_COMPLETE:String = "SERVER_UP_COMPLETE";
		public static const SERVER_UP_ERROR:String = "SERVER_UP_ERROR";
		
		public static const SERVER_DOWN_COMPLETE:String = "SERVER_DOWN_COMPLETE";
		public static const SERVER_DOWN_ERROR:String = "SERVER_DOWN_ERROR";
		
		public static const SERVER_UP_DETECTED:String = "SERVER_UP_DETECTED";
		public static const SERVER_DOWN_DETECTED:String = "SERVER_DOWN_DETECTED";
		
		public static const START_WATCH_COMPLETE:String = "START_WATCH_COMPLETE";
		public static const START_WATCH_ERROR:String = "START_WATCH_ERROR";
		
		public static const GET_AVAILABLE_SERVER_COMPLETE:String = "GET_AVAILABLE_SERVER_COMPLETE";
		public static const GET_AVAILABLE_SERVER_ERROR:String = "GET_AVAILABLE_SERVER_ERROR";
		
		public function ServersManagerEvent(type:String, data:Object = null, body:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, body, bubbles, cancelable);
		}
	}
}