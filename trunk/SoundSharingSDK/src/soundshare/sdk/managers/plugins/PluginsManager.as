package soundshare.sdk.managers.plugins
{
	import flashsocket.message.FlashSocketMessage;
	
	import soundshare.sdk.builders.messages.plugins.PluginsManagersMessageBuilder;
	import soundshare.sdk.managers.events.SecureClientEventDispatcher;
	import soundshare.sdk.managers.plugins.events.PluginsManagerEvent;
	import soundshare.sdk.plugins.manager.IPluginManager;
	
	public class PluginsManager extends SecureClientEventDispatcher
	{
		public static const LISTENER:String = "listener";
		public static const BROADCASTER:String = "broadcaster";
		public static const CONFIGURATION:String = "configuration";
		
		private var messageBuilder:PluginsManagersMessageBuilder;
		private var activePlugins:Vector.<IPluginManager> = new Vector.<IPluginManager>();
		
		public function PluginsManager()
		{
			super();
			
			messageBuilder = new PluginsManagersMessageBuilder(this);
			
			addAction("PLUGIN_EXIST", executeExistRequest);
			addAction("PLUGIN_REQUEST", executePluginRequest);
			addAction("GET_PLUGIN_ACTIVITY", executeGetPluginActivity);
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
			var sender:Array = getMessageSender(message);
			
			var body:Object = message.getJSONBody();
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
			
			var sender:Array = getMessageSender(message);
			
			var body:Object = message.getJSONBody();
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
		
		public function getPluginActivity(data:Object):void
		{
			trace("-PluginsManager[getPluginActivity]-");
			
			var message:FlashSocketMessage = messageBuilder.buildGetPluginActivityMessage(data);
			
			if (message)
				send(message);
		}
		
		public function executeGetPluginActivity(message:FlashSocketMessage):void
		{
			trace("-PluginsManager[executeGetPluginActivity]-");
			
			var sender:Array = getMessageSender(message);
			var matchData:Object = message.getJSONBody();
			var len:int = activePlugins.length;
			
			var data:Object;
			
			for (var i:int = 0;i < len;i ++)
			{
				data = activePlugins[i].match(matchData);
				
				if (data)
					break;
			}
			
			if (data)
				dispatchSocketEvent({
					event: {
						type: PluginsManagerEvent.ACTIVE,
						data: data
					},
					receiver: sender
				});
			else
				dispatchSocketEvent({
					event: {
						type: PluginsManagerEvent.NOT_ACTIVE,
						data: {
							error: "Plugin is not active.",
							code: 100
						}
					},
					receiver: sender
				});
		}
		
		public function addActivePlugin(plugin:IPluginManager):void
		{
			activePlugins.push(plugin);
			trace("-PluginsManager[addActivePlugin]-", plugin, activePlugins.length);
		}
		
		public function removeActivePlugin(plugin:IPluginManager):void
		{
			var index:int = activePlugins.indexOf(plugin);
			
			trace("1.-PluginsManager[removeActivePlugin]-", plugin, index, activePlugins.length);
			activePlugins.splice(index, 1);
			trace("2.-PluginsManager[removeActivePlugin]-", plugin, index, activePlugins.length);
		}
	}
}