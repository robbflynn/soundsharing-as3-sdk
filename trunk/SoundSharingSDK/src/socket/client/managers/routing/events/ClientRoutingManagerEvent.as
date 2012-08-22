package socket.client.managers.routing.events
{
	import flash.events.Event;
	
	import socket.message.FlashSocketMessage;
	
	public class ClientRoutingManagerEvent extends Event
	{
		public static const IDENTIFIED:String = "identified";
		
		public var data:Object;
		
		public function ClientRoutingManagerEvent(type:String, data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.data = data;
		}
	}
}