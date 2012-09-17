package soundshare.sdk.builders.messages.events
{
	import flashsocket.client.builders.message.events.ClientEventMessageBuilder;
	import flashsocket.message.FlashSocketMessage;
	
	import soundshare.sdk.managers.events.SecureClientEventDispatcher;

	public class SecureClientEventMessageBuilder extends ClientEventMessageBuilder
	{
		public function SecureClientEventMessageBuilder(target:SecureClientEventDispatcher)
		{
			super(target);
		}
		
		override protected function prepare():void
		{
			this.message = new FlashSocketMessage();
			this.messageHeader = {
				route: {
					sender: null,
					receiver: null
				},
				data: {
					token: token,
						action: {
							xtype: null,
							data: {
								type: null
							}
						}
				}
			};
			
			this.dispatchEventMessage = new FlashSocketMessage();
			this.dispatchEventMessageHeader = {
				route: {
					sender: null,
					receiver: null
				},
				data: {
					token: token,
						action: {
							xtype: "DISPATCH_EVENT",
							data: null
						}
				}
			};
		}
		
		override protected function build(xtype:String, eventType:String, receiverRoute:Array = null):FlashSocketMessage
		{
			if (!xtype)
				return null;
			
			messageHeader.route.sender = target.route;
			messageHeader.route.receiver = receiverRoute ? receiverRoute : target.receiverRoute;
			
			messageHeader.data.token = token;
			messageHeader.data.action.xtype = xtype;
			messageHeader.data.action.data.type = eventType;
			
			message.setJSONHeader(messageHeader);
			
			return message;
		}
		
		override public function buildDispatchEvent():FlashSocketMessage
		{
			dispatchEventMessageHeader.data.token = token;
			dispatchEventMessageHeader.route.sender = target.route;
			dispatchEventMessage.clearBody();
			
			return dispatchEventMessage;
		}
		
		private function get token():String
		{
			return (target as SecureClientEventDispatcher).token;
		}
	}
}