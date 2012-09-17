package soundshare.sdk.controllers.connection.client
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flashsocket.client.FlashSocketClient;
	import flashsocket.client.base.ClientSocketUnit;
	import flashsocket.client.events.FlashSocketClientEvent;
	import flashsocket.client.managers.routing.ClientRoutingManager;
	import flashsocket.client.managers.routing.events.ClientRoutingManagerEvent;
	import flashsocket.message.FlashSocketMessage;
	
	import soundshare.sdk.controllers.connection.client.events.ClientConnectionEvent;
	
	public class ClientConnection extends ClientSocketUnit
	{
		private var _client:FlashSocketClient;
		private var _router:ClientRoutingManager;
		
		private var _data:Object;
		
		private var keepAliveTimer:Timer;
		private var keepAliveMessage:FlashSocketMessage = new FlashSocketMessage();
		
		public var keepAliveTimeOut:int = 1000 * 60;
		
		public var name:String;
		public var critical:Boolean = false;
		
		public function ClientConnection()
		{
			super();
			
			_client = new FlashSocketClient();
			_client.addEventListener(FlashSocketClientEvent.CONNECTED, onConnected);
			_client.addEventListener(FlashSocketClientEvent.DISCONNECTED, onDisconnected);
			_client.addEventListener(FlashSocketClientEvent.ERROR, onError);
			_client.addEventListener(FlashSocketClientEvent.MESSAGE, onMessage);
			
			_router = new ClientRoutingManager(_client);
			_router.addEventListener(ClientRoutingManagerEvent.IDENTIFIED, onIdetified);
			_router.addUnit(this);
			
			keepAliveTimer = new Timer(keepAliveTimeOut, 1);
			keepAliveTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onKeepAliveTimerComplete);
		}
		
		private function onKeepAliveTimerComplete(e:TimerEvent):void
		{
			if (online)
			{
				client.send(keepAliveMessage);
				
				keepAliveTimer.delay = keepAliveTimeOut;
				keepAliveTimer.start();
			}
		}
		
		public function connect():void
		{
			trace("ConnectionController[connect]");
			
			keepAliveTimer.reset();
			
			if (client.connected)
				client.disconnect();
			
			client.connect();
		}
		
		public function disconnect():void
		{
			trace("ConnectionController[disconnect]");
			
			keepAliveTimer.reset();
			client.disconnect();
		}
		
		protected function onConnected(e:FlashSocketClientEvent):void 
		{
			router.connected();
			
			keepAliveTimer.start();
			dispatchEvent(new FlashSocketClientEvent(FlashSocketClientEvent.CONNECTED));
		}
		
		private function onDisconnected(e:FlashSocketClientEvent):void 
		{
			router.disconnected();
			
			keepAliveTimer.reset();
			dispatchEvent(new FlashSocketClientEvent(FlashSocketClientEvent.DISCONNECTED));
		}
		
		private function onError(e:FlashSocketClientEvent):void 
		{
			trace("ConnectionController[onError]");
			
			keepAliveTimer.reset();
			dispatchEvent(new FlashSocketClientEvent(FlashSocketClientEvent.ERROR));
		}
		
		private function onMessage(e:FlashSocketClientEvent):void 
		{
			//trace("-onMessage-", e.message.$header);
			
			router.process(e.message);
			dispatchEvent(new FlashSocketClientEvent(FlashSocketClientEvent.MESSAGE, e.message));
		}
		
		private function onIdetified(e:ClientRoutingManagerEvent):void 
		{
			trace("ConnectionController[onIdetified]:", e.data.sessionId);
			
			id = e.data.sessionId;
			router.remoteRegisterRoutingMap();
			
			dispatchEvent(new ClientConnectionEvent(ClientConnectionEvent.INITIALIZATION_COMPLETE, e.data));
		}
		
		public function set address(value:String):void
		{
			client.address = value;
		}
		
		public function get address():String
		{
			return client.address;
		}
		
		public function set port(value:int):void
		{
			client.port = value;
		}
		
		public function get port():int
		{
			return client.port;
		}
		
		public function get client():FlashSocketClient
		{
			return _client;
		}
		
		public function get router():ClientRoutingManager
		{
			return _router;
		}
		
		public function get data():Object
		{
			return _data;
		}
	}
}