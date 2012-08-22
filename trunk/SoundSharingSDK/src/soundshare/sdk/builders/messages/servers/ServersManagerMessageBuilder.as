package soundshare.sdk.builders.messages.servers
{
	import socket.message.FlashSocketMessage;
	
	import soundshare.sdk.managers.events.SecureClientEventDispatcher;

	public class ServersManagerMessageBuilder
	{
		public var target:SecureClientEventDispatcher;
		
		public function ServersManagerMessageBuilder(target:SecureClientEventDispatcher)
		{
			this.target = target;
		}
		
		protected function build(xtype:String):FlashSocketMessage
		{
			if (!xtype)
				throw new Error("Invalid xtype!");
			
			var message:FlashSocketMessage = new FlashSocketMessage();
			message.setJSONHeader({
				route: {
					sender: target.route,
					receiver: target.receiverRoute
				},
				data: {
					token: target.token,
					action: {
						xtype: xtype
					}
				}
			});
			
			return message;
		}
		
		public function buildGetAvailableServerMessage(plugins:Array = null):FlashSocketMessage
		{
			var message:FlashSocketMessage = build("GET_AVAILABLE_SERVER");
			message.setJSONBody({
				plugins: plugins ? plugins : []
			});
			
			return message;
		}
		
		public function buildServerUpMessage(serverId:String):FlashSocketMessage
		{
			var message:FlashSocketMessage = build("SERVER_UP");
			message.setJSONBody({
				serverId: serverId
			});
			
			return message;
		}
		
		public function buildServerDownMessage(serverId:String):FlashSocketMessage
		{
			var message:FlashSocketMessage = build("SERVER_DOWN");
			message.setJSONBody({
				serverId: serverId
			});
			
			return message;
		}
		
		public function buildShutDownServerMessage(serverId:String):FlashSocketMessage
		{
			var message:FlashSocketMessage = build("SHUT_DOWN_SERVER");
			message.setJSONBody({
				serverId: serverId
			});
			
			return message;
		}
		
		public function buildStartWatchServers(servers:Array, watchUp:Boolean = true, watchDown:Boolean = true):FlashSocketMessage
		{
			var message:FlashSocketMessage = build("START_WATCH");
			message.setJSONBody({
				servers: servers,
				up: watchUp,
				down: watchDown
			});
			
			return message;
		}
		
		public function buildStopWatchServers(servers:Array, watchUp:Boolean = true, watchDown:Boolean = true):FlashSocketMessage
		{
			var message:FlashSocketMessage = build("STOP_WATCH");
			message.setJSONBody({
				servers: servers,
				up: watchUp,
				down: watchDown
			});
			
			return message;
		}
	}
}