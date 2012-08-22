package soundshare.sdk.managers.plugins.request.events
{
	import flash.events.Event;
	
	import soundshare.sdk.plugins.manager.IPluginManager;
	import soundshare.sdk.plugins.view.IPluginView;
	
	public class PluginRequestEvent extends Event
	{
		public static const COMPLETE:String = "complete";
		public static const ERROR:String = "error";
		
		public var error:String;
		public var code:int;
		
		public var data:Object;
		
		public function PluginRequestEvent(type:String, data:Object=null, error:String=null, code:int=-1, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.data = data;
			this.error = error;
			this.code = code;
		}
	}
}