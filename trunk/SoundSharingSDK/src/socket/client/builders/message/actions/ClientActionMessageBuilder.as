package socket.client.builders.message.actions
{
	import flash.utils.ByteArray;
	
	import socket.message.FlashSocketMessage;
	import socket.client.base.ClientSocketUnit;

	public class ClientActionMessageBuilder
	{
		public var target:ClientSocketUnit;
		
		protected var message:FlashSocketMessage;
		protected var messageHeader:Object;
		
		protected var dispatchEventMessage:FlashSocketMessage;
		protected var dispatchEventMessageHeader:Object;
		
		public function ClientActionMessageBuilder(target:ClientSocketUnit = null)
		{
			this.target = target;
			
			this.message = new FlashSocketMessage();
			this.messageHeader = {
				route: {
					sender: null,
					receiver: null
				},
				data: {
				}
			};
		}
		
		public function build(action:Object, body:ByteArray = null, senderRoute:Array = null, receiverRoute:Array = null):FlashSocketMessage
		{
			if (!action && !action.xtype)
				throw new Error("invalid action!");
			
			messageHeader.route.sender = senderRoute ? senderRoute : target.route;
			messageHeader.route.receiver = receiverRoute ? receiverRoute : target.receiverRoute;
			
			messageHeader.data.action = action;
			
			message.setJSONHeader(messageHeader);
			
			if (body)
				message.writeBodyBytes(body);
			
			return message;
		}
	}
}