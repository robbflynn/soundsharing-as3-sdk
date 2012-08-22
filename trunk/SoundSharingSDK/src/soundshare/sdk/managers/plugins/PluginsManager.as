package soundshare.sdk.managers.plugins
{
	import socket.message.FlashSocketMessage;
	
	import soundshare.sdk.builders.messages.plugins.PluginsManagersMessageBuilder;
	import soundshare.sdk.managers.events.SecureClientEventDispatcher;
	import soundshare.sdk.managers.plugins.events.PluginsManagerEvent;
	
	public class PluginsManager extends SecureClientEventDispatcher
	{
		public static const LISTENER:String = "listener";
		public static const BROADCASTER:String = "broadcaster";
		
		private var messageBuilder:PluginsManagersMessageBuilder;
		
		public function PluginsManager()
		{
			super();
			
			messageBuilder = new PluginsManagersMessageBuilder(this);
			
			addAction("PLUGIN_EXIST", executeExistRequest);
			addAction("PLUGIN_REQUEST", executePluginRequest);
		}
		
		override protected function $dispatchSocketEvent(message:FlashSocketMessage):void
		{
			var event:Object = getActionData(message);
			
			if (event)
				dispatchEvent(new PluginsManagerEvent(event.type, event.data));
		}
		
		public function pluginExist(_id:String):void
		{
			trace("-PluginsManager[pluginExist]-", token);
			
			var message:FlashSocketMessage = messageBuilder.buildPluginExistMessage(_id);
			
			if (message)
				send(message);
		}
		
		public function executeExistRequest(message:FlashSocketMessage):void
		{
			var header:Object = message.getJSONHeader();
			var body:Object = message.getJSONBody();
			
			var sender:Array = header.route.sender;
			var _id:String = body._id;
			
			trace("-PluginsManager[executeExistRequest]-", token);
			
			dispatchEvent(new PluginsManagerEvent(PluginsManagerEvent.PLUGIN_EXIST, {
				_id: _id, 
				sender: sender
			}));
		}
		
		public function dispatchPluginExistComplete(receiver:Array):void
		{
			trace("-executePluginRequest[dispatchPluginRequestComplete]-", receiver);
			
			dispatchSocketEvent({
				event: {
					type: PluginsManagerEvent.PLUGIN_EXIST_COMPLETE
				},
				receiver: receiver
			});
		}
		
		public function dispatchPluginExistError(receiver:Array, error:String, code:int):void
		{
			trace("-executePluginRequest[dispatchPluginRequestError]-", receiver);
			
			dispatchSocketEvent({
				event: {
					type: PluginsManagerEvent.PLUGIN_EXIST_ERROR,
					data: {
						error: error,
						code: code
					}
				},
				receiver: receiver
			});
		}
		
		public function pluginRequest(_id:String, type:String, data:Object):void
		{
			trace("-PluginsManager[pluginRequest]-");
			
			var message:FlashSocketMessage = messageBuilder.buildPluginRequestMessage(_id, type, data);
			
			if (message)
				send(message);
		}
		
		public function executePluginRequest(message:FlashSocketMessage):void
		{
			trace("-PluginsManager[executePluginRequest]-");
			
			var header:Object = message.getJSONHeader();
			var body:Object = message.getJSONBody();
			
			var sender:Array = header.route.sender;
			var _id:String = body._id;
			var type:String = body.type;
			var data:Object = body.data;
			
			dispatchEvent(new PluginsManagerEvent(PluginsManagerEvent.PLUGIN_REQUEST, {
				_id: _id, 
				type: type,
				data: data, 
				sender: sender
			}));
		}
		
		public function dispatchPluginRequestComplete(receiver:Array, data:Object):void
		{
			trace("-executePluginRequest[dispatchPluginRequestComplete]-", receiver);
			
			dispatchSocketEvent({
				event: {
					type: PluginsManagerEvent.PLUGIN_REQUEST_COMPLETE,
					data: data
				},
				receiver: receiver
			});
		}
		
		public function dispatchPluginRequestError(receiver:Array, error:String, code:int):void
		{
			trace("-executePluginRequest[dispatchPluginRequestError]-", receiver);
			
			dispatchSocketEvent({
				event: {
					type: PluginsManagerEvent.PLUGIN_REQUEST_ERROR,
					data: {
						error: error,
						code: code
					}
				},
				receiver: receiver
			});
		}
	}
}