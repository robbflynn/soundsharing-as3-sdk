package socket.message
{
	import flash.utils.ByteArray;
	
	import socket.json.JSONFacade;

	public class FlashSocketMessage
	{
		private var header:ByteArray = new ByteArray();
		private var body:ByteArray = new ByteArray();
		
		private var jsonHeader:Object;
		private var jsonBody:Object;
		
		public function FlashSocketMessage(data:ByteArray = null)
		{
			readData(data);
		}
		
		public function clear():void
		{
			header.clear();
			body.clear();
		}
		
		public function readData(data:ByteArray):void
		{
			if (data && data.length > 8)
			{
				data.position = 0;
				var bd:String = data.readUTFBytes(2);
				data.position = data.length - 2;
				var ed:String = data.readUTFBytes(2);
				
				if (bd == "{#" && ed == "#}")
				{
					clear();
					
					data.position = 2;
					var headerLength:int = data.readInt();
					var bodyLength:int = data.readInt();
					
					if (headerLength > 0)
						data.readBytes(header, 0, headerLength);
					
					if (bodyLength > 0)
						data.readBytes(body, 0, bodyLength);
				}
			}
		}
		
		public function getData():ByteArray
		{
			var d:ByteArray = new ByteArray();
			
			d.writeUTFBytes("{#");
			d.writeInt(header.length);
			d.writeInt(body.length);
			d.writeBytes(header);
			d.writeBytes(body);
			d.writeUTFBytes("#}");
			
			return d;
		}
		
		// *********************************************************************************************************************
		// 															HEADER
		// *********************************************************************************************************************
		
		public function clearHeader():void
		{
			jsonHeader = null;
			header.clear();
		}
		
		public function writeHeaderUTFBytes(value:String):void
		{
			jsonHeader = null;
			header.writeUTFBytes(value);
		}
		
		public function writeHeaderBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void
		{
			jsonHeader = null;
			header.writeBytes(bytes, offset, length);
		}
		
		public function get headerLength():uint
		{
			return header.length;
		}
		
		public function getJSONHeader():Object
		{
			try 
			{
				if (!jsonHeader)
					jsonHeader = JSONFacade.parse(header.toString());
				
				return jsonHeader;
			}
			catch(errObject:Error) { trace("FlashSocketMessage: Invalid JSONFacade header!"); }
			
			return null;
		}
		
		public function setJSONHeader(obj:Object):void
		{
			header.clear();
			
			if (obj)
				header.writeUTFBytes(JSONFacade.stringify(obj));
			
			jsonHeader = obj;
		}
		
		/*
		* Use $header only to read data not to modify it!!! 
		*/
		
		public function get $header():ByteArray
		{
			return header;
		}
		
		// *********************************************************************************************************************
		// 															BODY
		// *********************************************************************************************************************
		
		public function clearBody():void
		{
			jsonBody = null;
			body.clear();
		}
		
		public function writeBodyUTFBytes(value:String):void
		{
			jsonBody = null;
			body.writeUTFBytes(value);
		}
		
		public function writeBodyBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void
		{
			jsonBody = null;
			body.writeBytes(bytes, offset, length);
		}
		
		public function readBodyObject():Object
		{
			return body.readObject();
		}
		
		public function get bodyLength():uint
		{
			return body.length;
		}
		
		public function setJSONBody(obj:Object):void
		{
			body.clear();
			
			if (obj)
				body.writeUTFBytes(JSONFacade.stringify(obj));
			
			jsonBody = obj;
		}
		
		public function getJSONBody():Object
		{
			try 
			{
				if (!jsonBody)
					jsonBody = JSONFacade.parse(body.toString());
				
				return jsonBody;
			}
			catch(errObject:Error) { trace("FlashSocketMessage: Invalid JSONFacade body!"); }
			
			return null;
		}
		
		/*
		* Use $body only to read data not to modify it!!! 
		*/
		
		public function get $body():ByteArray
		{
			return body;
		}
		
		// *********************************************************************************************************************
		// *********************************************************************************************************************
		
		public function get length():uint
		{
			return header.length + body.length;
		} 
	}
}