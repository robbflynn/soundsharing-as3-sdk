package soundshare.sdk.controllers.connection.client.events
{
	import flash.events.Event;
	
	public class ClientConnectionEvent extends Event
	{
		public static const INITIALIZATION_COMPLETE:String = "initializationComplete";
		
		public var data:Object;
		
		public function ClientConnectionEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.data = data;
		}
	}
}