package soundshare.sdk.controllers.connections
{
	import flash.events.EventDispatcher;
	
	import flashsocket.client.events.FlashSocketClientEvent;
	
	import soundshare.sdk.controllers.connection.client.ClientConnection;
	import soundshare.sdk.controllers.connections.events.ConnectionsControllerEvent;
	
	public class ConnectionsController extends EventDispatcher
	{
		private var _connections:Vector.<ClientConnection> = new Vector.<ClientConnection>();
		private var _connectionsByName:Array = new Array();
		
		public function ConnectionsController()
		{
		}
		
		public function createConnection(name:String, critical:Boolean = false):ClientConnection
		{
			var c:ClientConnection = new ClientConnection();
			c.name = name;
			c.critical = critical;
			c.addEventListener(FlashSocketClientEvent.DISCONNECTED, onDisconnected);
			
			connections.push(c);
			connectionsByName[name] = c;
			
			return c;
		}
		
		public function destroyConnection(c:ClientConnection):void
		{
			var index:int = connections.indexOf(c);
			
			trace("destroyConnection:", c.online);
			
			c.removeEventListener(FlashSocketClientEvent.DISCONNECTED, onDisconnected);
			
			if (c.online)
				c.disconnect();
			
			connections.splice(index, 1);
			delete(connectionsByName[c.name]);
		}
		
		public function destroyConnectionByName(name:String):void
		{
			var c:ClientConnection = connectionsByName[name];
			var index:int = connections.indexOf(c);
			
			c.removeEventListener(FlashSocketClientEvent.DISCONNECTED, onDisconnected);
			
			connections.splice(index, 1);
			delete(connectionsByName[name]);
		}
		
		private function onDisconnected(e:FlashSocketClientEvent):void 
		{
			var c:ClientConnection = e.currentTarget as ClientConnection;
			
			if (c.critical)
			{
				closeAllConnections();
				dispatchEvent(new ConnectionsControllerEvent(ConnectionsControllerEvent.CRITICAL_DISCONNECT, c));
			}
			else
				dispatchEvent(new ConnectionsControllerEvent(ConnectionsControllerEvent.DISCONNECT, c));
		}
		
		public function closeAllConnections():void
		{
			var len:int = connections.length;
			
			for (var i:int = 0;i < len;i ++)
				connections[i].disconnect();
		}
		
		public function removeAllConnections():void
		{
			while (connections.length > 0)
				delete(connectionsByName[connections.shift().name]);
		}
		
		public function get connections():Vector.<ClientConnection>
		{
			return _connections;
		}
		
		public function get connectionsByName():Array
		{
			return _connectionsByName;
		}
	}
}