package soundshare.sdk.controllers.connections.events
{
	import flash.events.Event;
	
	import soundshare.sdk.controllers.connection.client.ClientConnection;
	
	public class ConnectionsControllerEvent extends Event
	{
		public static const CRITICAL_DISCONNECT:String = "criticalDisconnect";
		public static const DISCONNECT:String = "disconnect";
		
		public var connection:ClientConnection;
		
		public function ConnectionsControllerEvent(type:String, connection:ClientConnection=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.connection = connection;
		}
	}
}