package soundshare.sdk.managers.connections.manager
{
	import socket.message.FlashSocketMessage;
	
	import soundshare.sdk.builders.messages.connections.manager.ConnectionsManagerMessageBuilder;
	import soundshare.sdk.managers.connections.manager.events.ConnectionsManagerEvent;
	import soundshare.sdk.managers.events.SecureClientEventDispatcher;
	
	public class ConnectionsManager extends SecureClientEventDispatcher
	{
		private var messageBuilder:ConnectionsManagerMessageBuilder;
		
		public function ConnectionsManager()
		{
			super();
			
			messageBuilder = new ConnectionsManagerMessageBuilder(this);
		}
		
		override protected function $dispatchSocketEvent(message:FlashSocketMessage):void
		{
			var event:Object = getActionData(message);
			
			if (event)
				dispatchEvent(new ConnectionsManagerEvent(event.type, event.data));
		} 
		
		public function registerConnection(token:String, managers:Object):void
		{
			var message:FlashSocketMessage = messageBuilder.buildRegisterConnectionMessage(token, managers);
			
			if (message)
				send(message);
		}
	}
}