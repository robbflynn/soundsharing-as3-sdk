package soundshare.sdk.builders.messages.connections.server
{
	import socket.message.FlashSocketMessage;
	import socket.client.base.ClientSocketUnit;
	
	import soundshare.sdk.data.SoundShareContext;
	import soundshare.sdk.managers.events.SecureClientEventDispatcher;

	public class ConnectionsManagerMessageBuilder
	{
		public var target:SecureClientEventDispatcher;
		
		public function ConnectionsManagerMessageBuilder(target:SecureClientEventDispatcher)
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
		
		public function buildWatchForDisconnectMessage(targets:Array):FlashSocketMessage
		{
			var message:FlashSocketMessage = build("WATCH_FOR_DISCONNECT");
			message.setJSONBody({
				targets: targets
			});
			
			return message;
		}
	}
}