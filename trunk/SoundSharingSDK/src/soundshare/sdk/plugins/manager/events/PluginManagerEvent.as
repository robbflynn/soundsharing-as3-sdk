package soundshare.sdk.plugins.manager.events
{
	import flash.events.Event;
	
	public class PluginManagerEvent extends Event
	{
		public static const READY:String = "ready";
		public static const ERROR:String = "error";
		public static const DESTROY:String = "destroy";
		
		public var error:String;
		public var code:int;
		
		public var data:Object;
		
		public function PluginManagerEvent(type:String, data:Object=null, error:String=null, code:int=-1, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.data = data;
			this.error = error;
			this.code = code;
		}
	}
}