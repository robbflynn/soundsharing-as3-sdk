package socket.client.managers.actions
{
	import flash.utils.ByteArray;
	
	import socket.client.base.ClientSocketUnit;
	import socket.client.builders.message.actions.ClientActionMessageBuilder;
	import socket.message.FlashSocketMessage;
	
	public class ClientActionsManager extends ClientSocketUnit
	{
		private var actions:Array;
		
		protected var actionMessageBuilder:ClientActionMessageBuilder;
		
		public function ClientActionsManager(receiverRoute:Array=null)
		{
			super(receiverRoute);
			
			actions = new Array();
			actionMessageBuilder = new ClientActionMessageBuilder(this);
			
			addAction("IDENTIFY_UNIT_RESULT", executeIdentify);
		}
		
		override protected function processActions(message:FlashSocketMessage):Boolean
		{
			var xtype:String = getActionXType(message);
			
			if (xtype && actions[xtype] != null)
			{
				actions[xtype](message);
				return true;
			}
			
			return false;
		}
		
		protected function getActionXType(message:FlashSocketMessage):String
		{
			var header:Object = message.getJSONHeader();
			
			return header && header.data && header.data.action ? header.data.action.xtype : null;
		}
		
		protected function getActionData(message:FlashSocketMessage):Object
		{
			var header:Object = message.getJSONHeader();
			
			return header && header.data && header.data.action ? header.data.action.data : null;
		}
		
		public function addAction(name:String, callback:Function):void
		{
			actions[name] = callback;
		}
		
		public function removeAction(name:String):void
		{
			delete actions[name];
		}
		
		public function sendAction(params:Object):void
		{
			var xtype:String = params.xtype;
			var data:Object = params.data;
			var body:ByteArray = params.body;
			var sender:Array = params.sender;
			var receiver:Array = params.receiver;
			var receivers:Array = params.receivers;
			var message:FlashSocketMessage;
			
			if (receiver)
			{
				message = this.actionMessageBuilder.build({
					xtype: xtype,
					data: data
				}, body, sender, receiver);
				
				send(message);
			}
			else
			if (receivers && receivers.length > 0)
			{
				while (receivers.length > 0)
				{
					message = actionMessageBuilder.build({
						xtype: xtype,
						data: data
					}, body, sender, receivers.shift());
					
					send(message);
				}
			}
			else
			if (receiverRoute)
			{
				message = this.actionMessageBuilder.build({
					xtype: xtype,
					data: data
				}, body, sender);
				
				send(message);
			}
		}
		
		protected function executeIdentify(message:FlashSocketMessage):void
		{
			var header:Object = message.getJSONHeader();
			var action:Object = header.data.action;
			
			if (action && action.data && action.data.route)
				receiverRoute = action.data.route;
		}
	}
}