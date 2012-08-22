package socket.client.managers.routing
{
	import socket.client.FlashSocketClient;
	import socket.client.base.ClientSocketUnit;
	import socket.client.managers.actions.ClientActionsManager;
	import socket.client.managers.routing.events.ClientRoutingManagerEvent;
	import socket.message.FlashSocketMessage;
	
	public class ClientRoutingManager extends ClientActionsManager
	{
		public var client:FlashSocketClient;
		
		public var remoteIdentifyAllOnConnect:Boolean = false;
		public var remoteRegisterAllOnConnect:Boolean = false;
		
		private var _localRoutingMap:Object = new Object();
		private var _remoteRoutingMap:Object;
		
		public function ClientRoutingManager(client:FlashSocketClient = null)
		{
			super();
			
			this.client = client;
			
			addAction("IDENTIFY_ALL_UNITS_RESULT", $identifyAll);
		}
		
		override public function send(message:FlashSocketMessage):void
		{
			client.send(message);
		}
		
		override public function remoteIdentify(target:ClientSocketUnit = null):void
		{
			if (target.receiverNamespace)
				sendAction({
					xtype: "IDENTIFY_UNIT",
					data: {
						receiverNamespace: target.receiverNamespace
					},
					sender: target.route,
					receiver: route
				});
		}
		
		public function remoteIdentifyAll():void
		{
			sendAction({
				xtype: "IDENTIFY_ALL_UNITS",
				receiver: route
			});
		};
		
		public function $identifyAll(message:FlashSocketMessage):void
		{
			var header:Object = message.getJSONHeader();
			var action:Object = header.data.action;
			
			if (action && action.data && action.data.routingMap)
			{
				remoteRoutingMap = action.data.routingMap;
				identifyChildren();
				
				dispatchEvent(new ClientRoutingManagerEvent(ClientRoutingManagerEvent.IDENTIFIED, action.data));
			}
		}
		
		public function remoteRegisterRoutingMap():void
		{
			trace("ClientRoutingManager[remoteRegisterRoutingMap]: " + localRoutingMap);
			
			sendAction({
				xtype: "REGISTER_ROUTING_MAP",
				data: {
					routingMap: localRoutingMap
				},
				receiver: route
			});
		}
		
		override public function getLocalRoutingMap():Object
		{
			return localRoutingMap;
		}
		
		override public function getRemoteRoutingMap():Object
		{
			return remoteRoutingMap;
		}
		
		override public function connected():void
		{
			id = client.serverURL;
			register(true);
			
			if (remoteRegisterAllOnConnect)
				remoteRegisterRoutingMap();
			
			if (remoteIdentifyAllOnConnect)
				remoteIdentifyAll();
			
			super.connected();
		}
		
		override public function disconnected():void
		{
			_localRoutingMap = new Object();
			super.disconnected();
		}
		
		override public function get online():Boolean
		{
			return client.connected;
		}
		
		public function set remoteRoutingMap(value:Object):void
		{
			_remoteRoutingMap = value;
		}
		
		public function get remoteRoutingMap():Object
		{
			return _remoteRoutingMap;
		}
		
		public function get localRoutingMap():Object
		{
			return _localRoutingMap;
		}
	}
}