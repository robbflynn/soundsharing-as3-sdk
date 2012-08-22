package soundshare.sdk.builders.messages.plugins
{
	import socket.message.FlashSocketMessage;
	
	import soundshare.sdk.managers.events.SecureClientEventDispatcher;

	public class PluginsManagersMessageBuilder
	{
		public var target:SecureClientEventDispatcher;
		
		public function PluginsManagersMessageBuilder(target:SecureClientEventDispatcher)
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
		
		public function buildPluginExistMessage(_id:String):FlashSocketMessage
		{
			var message:FlashSocketMessage =  build("PLUGIN_EXIST");
			message.setJSONBody({
				_id: _id
			});
			
			return message;
		}
		
		public function buildPluginRequestMessage(_id:String, type:String, data:Object):FlashSocketMessage
		{
			var message:FlashSocketMessage =  build("PLUGIN_REQUEST");
			message.setJSONBody({
				_id: _id,
				type: type,
				data: data
			});
			
			return message;
		}
	}
}