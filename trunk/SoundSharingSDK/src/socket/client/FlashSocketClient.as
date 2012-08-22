package socket.client
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import socket.client.events.FlashSocketClientEvent;
	import socket.message.FlashSocketMessage;
	
	[Event(name="connected", type="socket.client.events.FlashSocketClientEvent")]
	[Event(name="disconnected", type="socket.client.events.FlashSocketClientEvent")]
	[Event(name="message", type="socket.client.events.FlashSocketClientEvent")]
	[Event(name="error", type="socket.client.events.FlashSocketClientEvent")]
	
	public class FlashSocketClient extends EventDispatcher
	{
		public var address:String;
		public var port:int;
		
		private var socket:Socket;
		
		private var messageBuffer:ByteArray = new ByteArray();
		private var messageData:ByteArray = new ByteArray();
		
		private var tmpBuffer:ByteArray = new ByteArray()
		
		public var processMessage:Boolean = true;
		
		public function FlashSocketClient(address:String = null, port:int = 0)
		{
			super();
			
			this.address = address;
			this.port = port;
			
			socket = new Socket();
			socket.addEventListener(Event.CLOSE, closeHandler);
			socket.addEventListener(Event.CONNECT, connectHandler);
			socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		// ********************************************************************************************************
		// *********************************************** EVENTS *************************************************
		// ********************************************************************************************************
		
		protected function connectHandler(event:Event):void 
		{
			//trace("connectHandler: " + event);
			dispatchEvent(new FlashSocketClientEvent(FlashSocketClientEvent.CONNECTED));
		}
		
		protected function socketDataHandler(event:ProgressEvent):void 
		{
			//trace("-socketDataHandler-");
			if (processMessage)
				readData();
		}
		
		protected function closeHandler(event:Event):void 
		{
			//trace("closeHandler: " + event);
			
			clearBuffers();
			dispatchEvent(new FlashSocketClientEvent(FlashSocketClientEvent.DISCONNECTED));
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void 
		{
			trace("ioErrorHandler: " + event);
			
			clearBuffers();
			dispatchEvent(new FlashSocketClientEvent(FlashSocketClientEvent.ERROR));
		}
		
		protected function securityErrorHandler(event:SecurityErrorEvent):void 
		{
			trace("securityErrorHandler: " + event);
			
			clearBuffers();
			dispatchEvent(new FlashSocketClientEvent(FlashSocketClientEvent.ERROR));
		}
		
		// ********************************************************************************************************
		// ********************************************************************************************************
		// ********************************************************************************************************
		
		public function connect():void
		{
			if (socket.connected)
				socket.close();
				
			socket.connect(address, port);
		}
		
		public function disconnect():void
		{
			if (socket.connected)
			{
				socket.close();
				clearBuffers();
				
				dispatchEvent(new FlashSocketClientEvent(FlashSocketClientEvent.DISCONNECTED));
			}
		}
		
		public function send(message:FlashSocketMessage):void
		{
			socket.writeBytes(message.getData());
			socket.flush();
		}
		
		protected function processData(data:ByteArray):void
		{
			//trace("-processData-", data.length);
			dispatchEvent(new FlashSocketClientEvent(FlashSocketClientEvent.MESSAGE, new FlashSocketMessage(data)));
		}
		
		private function getMessageLength():int
		{
			messageBuffer.position = 2;
			return messageBuffer.readInt() + messageBuffer.readInt() + 12;
		}
		
		protected function readData():void 
		{
			//trace("1. ----------------------------- readData -----------------------------", messageBuffer.length, socket.bytesAvailable);
			
			socket.readBytes(messageBuffer, messageBuffer.length, socket.bytesAvailable);
			
			//trace("2. ----------------------------- readData -----------------------------", messageBuffer.length);
			
			if (messageBuffer.length >= 12)
			{
				var ln:int = getMessageLength();
				
				if (ln <= messageBuffer.length)
				{
					while (true)
					{
						messageBuffer.position = 0;
						messageBuffer.readBytes(messageData, 0, ln);
						
						processData(messageData);
						
						if (messageData.length != messageBuffer.length)
						{
							messageBuffer.readBytes(tmpBuffer, 0, messageBuffer.length - messageBuffer.position);
							messageBuffer.clear();
							
							tmpBuffer.readBytes(messageBuffer, 0, tmpBuffer.length);
							tmpBuffer.clear();
							
							messageData.clear();
							
							if (messageBuffer.length >= 12)
							{
								ln = getMessageLength();
								
								if (ln > messageBuffer.length)
									break;
							}
							else
								break;
						}
						else
						{
							messageData.clear();
							messageBuffer.clear();
							break;
						}
					}
				}
			}
		}
		
		protected function clearBuffers():void
		{
			messageBuffer.clear(); 
			messageData.clear(); 
			tmpBuffer.clear();
		}
		
		public function get serverURL():String
		{
			if (address)
				return port ? address + ":" + port : address;
			
			return null;
		}
		
		public function get connected():Boolean
		{
			return socket.connected;
		}
	}
}