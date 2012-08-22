package socket.client.events
{
	import flash.events.Event;
	
	import socket.message.FlashSocketMessage;
	
	public class FlashSocketClientEvent extends Event
	{
		public static const CONNECTED:String = "connected";
		public static const DISCONNECTED:String = "disconnected";
		public static const MESSAGE:String = "message";
		public static const ERROR:String = "error";
		
		public var message:FlashSocketMessage;
		
		public function FlashSocketClientEvent(type:String, message:FlashSocketMessage=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.message = message;
		}
	}
}