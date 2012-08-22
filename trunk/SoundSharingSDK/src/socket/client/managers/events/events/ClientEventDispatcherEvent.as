package socket.client.managers.events.events
{
	import flash.events.Event;
	
	public class ClientEventDispatcherEvent extends Event
	{
		private var _data:Object;
		private var _body:Object;
		
		public function ClientEventDispatcherEvent(type:String, data:Object=null, body:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
			this.body = body;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set body(value:Object):void
		{
			_body = value;
		}
		
		public function get body():Object
		{
			return _body;
		}
	}
}