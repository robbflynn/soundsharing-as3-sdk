package soundshare.sdk.managers.events
{
	import socket.client.builders.message.events.ClientEventMessageBuilder;
	import socket.client.managers.events.ClientEventDispatcher;
	
	import soundshare.sdk.builders.messages.events.SecureClientEventMessageBuilder;
	
	public class SecureClientEventDispatcher extends ClientEventDispatcher
	{
		public var token:String;
		
		public function SecureClientEventDispatcher(receiverRoute:Array=null, eventMessageBuilder:ClientEventMessageBuilder=null)
		{
			super(receiverRoute, eventMessageBuilder ? eventMessageBuilder : new SecureClientEventMessageBuilder(this));
		}
	}
}