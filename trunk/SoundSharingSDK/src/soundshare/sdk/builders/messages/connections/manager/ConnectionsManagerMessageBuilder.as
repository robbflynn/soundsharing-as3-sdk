package soundshare.sdk.builders.messages.connections.manager
{
	import socket.message.FlashSocketMessage;
	
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
		
		public function buildRegisterConnectionMessage(token:String, managers:Object):FlashSocketMessage
		{
			var message:FlashSocketMessage = build("REGISTER_CONNECTION");
			message.setJSONBody({
				token: token,
				managers: managers
			});
			
			return message;
		}
	}
}