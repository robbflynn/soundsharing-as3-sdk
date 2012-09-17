package soundshare.sdk.managers.servers
{
	import flashsocket.message.FlashSocketMessage;
	
	import soundshare.sdk.builders.messages.servers.ServersManagerMessageBuilder;
	import soundshare.sdk.managers.events.SecureClientEventDispatcher;
	import soundshare.sdk.managers.servers.events.ServersManagerEvent;
	
	public class ServersManager extends SecureClientEventDispatcher
	{
		private var messageBuilder:ServersManagerMessageBuilder;
		
		public function ServersManager()
		{
			super();
			
			messageBuilder = new ServersManagerMessageBuilder(this);
		}
		
		override protected function $dispatchSocketEvent(message:FlashSocketMessage):void
		{
			var event:Object = getActionData(message);
			
			trace("ServersManager[$dispatchSocketEvent]:", event);
			
			if (event)
				dispatchEvent(new ServersManagerEvent(event.type, event.data));
		}
		
		public function getAvailableServer(plugins:Array = null):void
		{
			var message:FlashSocketMessage = messageBuilder.buildGetAvailableServerMessage(plugins);
			
			if (message)
				send(message);
		}
		
		/*public function serverUp(serverId:String):void
		{
			var message:FlashSocketMessage = messageBuilder.buildServerUpMessage(serverId);
			
			if (message)
				send(message);
		}
		
		public function serverDown(serverId:String):void
		{
			var message:FlashSocketMessage = messageBuilder.buildServerDownMessage(serverId);
			
			if (message)
				send(message);
		}*/
		
		public function shutDownServer(serverId:String):void
		{
			var message:FlashSocketMessage = messageBuilder.buildShutDownServerMessage(serverId);
			
			if (message)
				send(message);
		}
		
		public function startWatchServers(servers:Array, watchUp:Boolean = true, watchDown:Boolean = true):void
		{
			var message:FlashSocketMessage = messageBuilder.buildStartWatchServers(servers, watchUp, watchDown);
			
			if (message)
				send(message);
		}
		
		public function stopWatchServers(servers:Array, watchUp:Boolean = true, watchDown:Boolean = true):void
		{
			var message:FlashSocketMessage = messageBuilder.buildStopWatchServers(servers, watchUp, watchDown);
			
			if (message)
				send(message);
		}
	}
}