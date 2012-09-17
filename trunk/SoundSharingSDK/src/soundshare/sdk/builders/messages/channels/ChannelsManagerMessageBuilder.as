package soundshare.sdk.builders.messages.channels
{
	import flashsocket.message.FlashSocketMessage;
	
	import soundshare.sdk.managers.events.SecureClientEventDispatcher;

	public class ChannelsManagerMessageBuilder
	{
		public var target:SecureClientEventDispatcher;
		
		public function ChannelsManagerMessageBuilder(target:SecureClientEventDispatcher)
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
		
		public function buildStartWatchChannels(channels:Array, watchActivation:Boolean = true, watchDeactivation:Boolean = true):FlashSocketMessage
		{
			var message:FlashSocketMessage = build("START_WATCH");
			message.setJSONBody({
				channels: channels,
				activation: watchActivation,
				deactivation: watchDeactivation
			});
			
			return message;
		}
		
		public function buildStopWatchChannels(channels:Array, watchActivation:Boolean = true, watchDeactivation:Boolean = true):FlashSocketMessage
		{
			var message:FlashSocketMessage = build("STOP_WATCH");
			message.setJSONBody({
				channels: channels,
				activation: watchActivation,
				deactivation: watchDeactivation
			});
			
			return message;
		}
	}
}