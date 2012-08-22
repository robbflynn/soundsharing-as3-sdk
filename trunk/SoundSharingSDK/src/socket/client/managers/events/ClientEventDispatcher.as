package socket.client.managers.events
{
	import flash.utils.ByteArray;
	
	import socket.client.builders.message.events.ClientEventMessageBuilder;
	import socket.client.managers.actions.ClientActionsManager;
	import socket.client.managers.events.events.ClientEventDispatcherEvent;
	import socket.client.FlashSocketClient;
	import socket.message.FlashSocketMessage;
	import socket.client.base.ClientSocketUnit;
	import socket.utils.register.ObjectRegister;
	
	public class ClientEventDispatcher extends ClientActionsManager
	{
		protected var localListeners:Array;
		protected var socketListeners:ObjectRegister;
		
		protected var eventMessageBuilder:ClientEventMessageBuilder;
		
		public function ClientEventDispatcher(receiverRoute:Array = null, eventMessageBuilder:ClientEventMessageBuilder = null)
		{
			super(receiverRoute);
			
			this.localListeners = new Array();
			this.socketListeners = new ObjectRegister();
			
			this.eventMessageBuilder = eventMessageBuilder ? eventMessageBuilder : new ClientEventMessageBuilder(this);
			
			addAction("DISPATCH_EVENT", $dispatchSocketEvent);
			addAction("ADD_EVENT_LISTENER", $executeAddSocketEventListener);
			addAction("REMOVE_EVENT_LISTENER", $executeRemoveSocketEventListener);
			addAction("REMOVE_ALL_EVENT_LISTENERS", $executeRemoveAllSocketEventListeners);
			addAction("CLEAR_ALL_EVENT_LISTENERS", $executeClearAllEventListeners);
		}
		
		// ****************************************************************************************************************
		// ****************************************************************************************************************
		
		protected function dispatchSocketEvent(params:Object):Boolean
		{
			var event:Object = params.event;
			var eventBody:ByteArray = params.eventBody;
			var client:FlashSocketClient = params.client;
			var receiver:Array = params.receiver;
			var receivers:Array = params.receivers;
			
			if (!event || !event.type)
			{
				//trace("ClientEventDispatcher[dispatchSocketEvent]: Invalid socket event!");
				return false;
			}
			
			var type:String = event.type;
			var message:FlashSocketMessage;
			
			//trace("$ClientEventDispatcher[0.dispatchSocketEvent]["+event.type+"]: " + receiver + ":" + socketListeners.exist([type]));
			
			if (socketListeners.exist([type]))
			{
				if (receiver)
				{
					if (socketListeners.exist([type].concat(receiver)))
					{
						message = eventMessageBuilder.buildDispatchEvent(); // new FlashSocketMessage();
						
						if (eventBody)
							message.writeHeaderBytes(eventBody);
						
						eventMessageBuilder.prepareDispatchEventBuild(event, receiver);
						send(message);
						
						return true;
					}
				}
				else
				if (receivers)
				{
					if (receivers.length > 0)
					{
						message = eventMessageBuilder.buildDispatchEvent();
						
						if (eventBody)
							message.writeHeaderBytes(eventBody);
						
						while (receivers.length > 0)
						{
							receiver = receivers.shift();
							
							eventMessageBuilder.prepareDispatchEventBuild(event, receiver);
							send(message);
						}
						
						return true;
					}
				}
				else
				{
					receivers = socketListeners.buildMap([type], 1);
					
					if (receivers.length > 0)
					{
						message = eventMessageBuilder.buildDispatchEvent();
						
						if (eventBody)
							message.writeHeaderBytes(eventBody);
						
						while (receivers.length > 0)
						{
							receiver = receivers.shift();
							
							eventMessageBuilder.prepareDispatchEventBuild(event, receiver);
							send(message);
						}
						
						return true;
					}
				}
			}
			
			return false; 
		}
		
		protected function $dispatchSocketEvent(message:FlashSocketMessage):void
		{
			var event:Object = getActionData(message);
			
			//trace("ClientEventDispatcher[$dispatchSocketEvent]", event);
			
			if (event)
				dispatchEvent(new ClientEventDispatcherEvent(event.type, event.data, message.$body));
		}
		
		public function addSocketEventListener(type:String, listener:Function):void
		{
			addLocalSocketEventListener(type, listener);
			
			var message:FlashSocketMessage = eventMessageBuilder.buildAddEventListener(type);
			send(message);
			
			//trace("ClientEventDispatcher[addSocketEventListener]:", type);
		}
		
		public function addLocalSocketEventListener(type:String, listener:Function):void
		{
			if (!type || listener == null)
				throw new Error("Invalid type or listener!");
			
			addEventListener(type, listener);
			localListeners.push({type: type, listener: listener});
			
			//trace("ClientEventDispatcher[addLocalSocketEventListener]:", type);
		}
		
		protected function $executeAddSocketEventListener(message:FlashSocketMessage):void
		{
			var header:Object = message.getJSONHeader();
			var sender:Array = header.route.sender;
			
			var event:Object = getActionData(message);
			var type:String = event ? event.type : null;
			
			//trace("-ClientEventDispatcher[$executeAddSocketEventListener]-");
			
			$addSocketEventListener(sender, type);
		}
		
		public function $addSocketEventListener(target:Array, type:String):void
		{
			//trace("-ClientEventDispatcher[$addSocketEventListener]-");
			
			if (target && type)
			{
				var regPath:Array = [type].concat(target);
				var listener:Object = this.socketListeners.read(regPath);
				
				if (!listener)
					this.socketListeners.register(regPath, {total: 1});
				else
					listener.total ++; 
				
				//trace("-ClientEventDispatcher[$addSocketEventListener]["+this.socketListeners.read(regPath).total+"]:" + regPath);
			}
			else
				trace("-ClientEventDispatcher[$addSocketEventListener]: Invalid parameters!");
		}
		
		public function registerSocketEventListener(type:String):void
		{
			registerLocalSocketEventListener(type);
			
			var message:FlashSocketMessage = eventMessageBuilder.buildAddEventListener(type);
			send(message);
			
			//trace("ClientEventDispatcher[registerSocketEventListener]:", type);
		}
		
		public function registerLocalSocketEventListener(type:String):void
		{
			if (!type)
				throw new Error("Invalid type!");
			
			localListeners.push({type: type, listener: null});
			
			//trace("ClientEventDispatcher[registerLocalSocketEventListener]:", type);
		}
		
		public function removeSocketEventListener(type:String, listener:Function):void
		{
			var index:int = removeLocalSocketEventListener(type, listener);
			
			if (index != -1)
			{
				//trace("ClientEventDispatcher[removeSocketEventListener]:", type);
				
				var message:FlashSocketMessage = eventMessageBuilder.buildRemoveEventListener(type);
				
				removeEventListener(type, listener);
				send(message);
			}
			else
				trace("ClientEventDispatcher[removeSocketEventListener]: Listener not exist!");
		}
		
		public function removeLocalSocketEventListener(type:String, listener:Function):int
		{
			if (!type || listener == null)
				throw new Error("Invalid type or listener!");
			
			var index:int = -1;
			
			for (var i:int = 0;i < localListeners.length;i ++)
				if (type == localListeners[i].type && listener == localListeners[i].listener)
				{
					index = i;
					
					localListeners.splice(index, 1);
					break ;
				}
			
			//trace("ClientEventDispatcher[removeLocalSocketEventListener]:", type, index);
			
			return index;
		}
		
		protected function $executeRemoveSocketEventListener(message:FlashSocketMessage):void
		{
			//trace("-ClientEventDispatcher[$executeRemoveSocketEventListener]-");
			
			var header:Object = message.getJSONHeader();
			var sender:Array = header.route.sender;
			
			var event:Object = getActionData(message);
			var type:String = event ? event.type : null;
			
			$removeSocketEventListener(sender, type)
		}
		
		protected function $removeSocketEventListener(target:Array, type:String):void
		{
			//trace("-ClientEventDispatcher[$removeSocketEventListener]-");
			
			if (target && type)
			{
				var regPath:Array = [type].concat(target);
				var listener:Object = this.socketListeners.read(regPath);
				
				if (listener)
				{
					listener.total --;
					
					//trace("ClientEventDispatcher[2.$removeSocketEventListener]["+listener.total+"]:" + listener+":"+regPath);
					
					if (listener.total == 0)
						this.socketListeners.unregister(regPath);
				}
				else
					trace("ClientEventDispatcher[1.$removeSocketEventListener]: Listener not exist! ... " + regPath);
			}
			else
				trace("ClientEventDispatcher[$removeSocketEventListener]: Invalid parameters!");
		}
		
		public function removeAllSocketEventListeners(type:String = null):void
		{
			//trace("ClientEventDispatcher[removeAllSocketEventListeners]: ", type);
			
			removeAllLocalSocketEventListeners(type);
			
			var message:FlashSocketMessage = eventMessageBuilder.buildRemoveAllEventListeners(type);
			send(message);
		}
		
		public function removeAllLocalSocketEventListeners(type:String = null):void
		{
			if (type)
			{
				var i:int = localListeners.length;
				
				while (i > 0)
				{
					i --;
					
					if (localListeners[i].type == type)
						localListeners.splice(i, 1);
				}
			}
			else
				while (localListeners.length > 0)
				{
					var event:Object = localListeners.shift();
					removeEventListener(event.type, event.listener);
				}
			
			//trace("ClientEventDispatcher[removeAllLocalSocketEventListeners]: ", type);
		}
		
		protected function $executeRemoveAllSocketEventListeners(message:FlashSocketMessage):void
		{
			var header:Object = message.getJSONHeader();
			var sender:Array = header.route.sender;
			
			var event:Object = getActionData(message);
			var type:String = event ? event.type : null;
			
			//trace("ClientEventDispatcher[$executeRemoveAllSocketEventListeners]: ", type);
			
			$removeAllSocketEventListeners(sender, type);
		}
		
		public function $removeAllSocketEventListeners(target:Array, type:String = null):void
		{
			//trace("ClientEventDispatcher[$removeAllSocketEventListeners]: ", type);
			
			if (type)
				socketListeners.remove([type].concat(target));
			else
				socketListeners.removeByPattern(["*"].concat(target));
		}
		
		public function unregisterSocketEventListener(type:String):void
		{
			var index:int = unregisterLocalSocketEventListener(type);
			
			if (index != -1)
			{
				//trace("ClientEventDispatcher[unregisterSocketEventListener]:", type);
				
				var message:FlashSocketMessage = eventMessageBuilder.buildRemoveEventListener(type);
				send(message);
			}
			else
				trace("ClientEventDispatcher[unregisterSocketEventListener]: Listener not exist!");
		}
		
		public function unregisterLocalSocketEventListener(type:String):int
		{
			if (!type)
				throw new Error("Invalid type!");
			
			var index:int = -1;
			
			for (var i:int = 0;i < localListeners.length;i ++)
				if (type == localListeners[i].type)
				{
					index = i;
					
					localListeners.splice(index, 1);
					break ;
				}
			
			//trace("ClientEventDispatcher[unregisterLocalSocketEventListener]:", type, index);
			
			return index;
		}
		
		public function $executeClearAllEventListeners(message:FlashSocketMessage):void
		{
			//trace("ClientEventDispatcher[$executeClearAllEventListeners]:");
			
			var header:Object = message.getJSONHeader();
			var sender:Array = header.route.sender;
			
			$removeAllSocketEventListeners(sender);
		}
		
		public function clearAllEventListeners():void
		{
			var receivers:Array = socketListeners.buildMap([], 1, true);
			var receiver:Array;
			var message:FlashSocketMessage;
			
			//trace("ClientEventDispatcher[clearAllEventListeners]:", receivers ? receivers.length : "NULL");
			
			if (receivers)
				while (receivers.length > 0)
				{
					receiver = receivers.shift();
					message = eventMessageBuilder.buildClearAllEventListeners(receiver);
					
					send(message);
				}
			
			removeAllSocketEventListeners();
			socketListeners.clear();
		}
		
		// ****************************************************************************************************************
		// ****************************************************************************************************************
		
		override public function beforeRemove():void
		{
			//trace("----------------- beforeRemove -----------------", online);
			if (online)
				clearAllEventListeners();
		}
		
		override public function disconnected():void
		{
			removeAllLocalSocketEventListeners();
			socketListeners.clear();
			
			super.disconnected();
		}
	}
}