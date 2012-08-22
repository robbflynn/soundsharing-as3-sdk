package socket.client.builders.message.events
{
	import socket.message.FlashSocketMessage;
	import socket.client.base.ClientSocketUnit;

	public class ClientEventMessageBuilder
	{
		public var target:ClientSocketUnit;
		
		protected var message:FlashSocketMessage;
		protected var messageHeader:Object;
		
		protected var dispatchEventMessage:FlashSocketMessage;
		protected var dispatchEventMessageHeader:Object;
		
		public function ClientEventMessageBuilder(target:ClientSocketUnit = null)
		{
			this.target = target;
			
			prepare();
		}
		
		protected function prepare():void
		{
			this.message = new FlashSocketMessage();
			this.messageHeader = {
				route: {
					sender: null,
					receiver: null
				},
				data: {
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
					action: {
						xtype: "DISPATCH_EVENT",
						data: null
					}
				}
			};
		}
		
		protected function build(xtype:String, eventType:String, receiverRoute:Array = null):FlashSocketMessage
		{
			if (!xtype)
				return null;
			
			messageHeader.route.sender = receiverRoute ? receiverRoute : target.route;
			messageHeader.route.receiver = target.receiverRoute;
			
			messageHeader.data.action.xtype = xtype;
			messageHeader.data.action.data.type = eventType;
			
			message.setJSONHeader(messageHeader);
			
			return message;
		}
		
		public function buildDispatchEvent():FlashSocketMessage
		{
			dispatchEventMessageHeader.route.sender = target.route;
			dispatchEventMessage.clearBody();
			
			return dispatchEventMessage;
		}
		
		public function prepareDispatchEventBuild(event:Object, receiver:Array = null):void
		{
			dispatchEventMessageHeader.route.receiver = receiver ? receiver : target.receiverRoute;
			dispatchEventMessageHeader.data.action.data = event;
			
			dispatchEventMessage.setJSONHeader(dispatchEventMessageHeader);
		}
		
		public function buildAddEventListener(type:String):FlashSocketMessage
		{
			return build("ADD_EVENT_LISTENER", type);
		}
		
		public function buildRemoveEventListener(type:String):FlashSocketMessage
		{
			return build("REMOVE_EVENT_LISTENER", type);
		}
		
		public function buildRemoveAllEventListeners(type:String):FlashSocketMessage
		{
			return build("REMOVE_ALL_EVENT_LISTENERS", type);
		}
		
		public function buildClearAllEventListeners(receiverRoute:Array = null):FlashSocketMessage
		{
			return build("CLEAR_ALL_EVENT_LISTENERS", null, receiverRoute);
		}
	}
}