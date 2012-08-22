package soundshare.sdk.managers.plugins.events
{
	import socket.client.managers.events.events.ClientEventDispatcherEvent;
	
	public class PluginsManagerEvent extends ClientEventDispatcherEvent
	{
		public static const PLUGIN_REQUEST:String = "PLUGIN_REQUEST";
		
		public static const PLUGIN_REQUEST_COMPLETE:String = "PLUGIN_REQUEST_COMPLETE";
		public static const PLUGIN_REQUEST_ERROR:String = "PLUGIN_REQUEST_ERROR";
		
		public static const PLUGIN_EXIST:String = "PLUGIN_EXIST";
		
		public static const PLUGIN_EXIST_COMPLETE:String = "PLUGIN_EXIST_COMPLETE";
		public static const PLUGIN_EXIST_ERROR:String = "PLUGIN_EXIST_ERROR";
		
		public function PluginsManagerEvent(type:String, data:Object = null, body:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, body, bubbles, cancelable);
		}
	}
}