package soundshare.sdk.managers.connections.server
{
	import flashsocket.message.FlashSocketMessage;
	
	import soundshare.sdk.builders.messages.connections.server.ConnectionsManagerMessageBuilder;
	import soundshare.sdk.managers.connections.server.events.ConnectionsManagerEvent;
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
		
		public function watchForDisconnect(targets:Array):void
		{
			trace("watchForDisconnect:", targets);
			
			var message:FlashSocketMessage = messageBuilder.buildWatchForDisconnectMessage(targets);
			
			if (message)
				send(message);
		}
	}
}