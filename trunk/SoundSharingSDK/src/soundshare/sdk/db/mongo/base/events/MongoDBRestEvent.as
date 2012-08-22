package soundshare.sdk.db.mongo.base.events
{
	import flash.events.Event;
	
	public class MongoDBRestEvent extends Event
	{
		public static const COMPLETE:String = "complete";
		public static const PROGRESS:String = "progress";
		public static const ERROR:String = "error";
		
		public var data:Object;
		
		public var bytesLoaded:Number;
		public var bytesTotal:Number;
		
		public var error:String;
		public var code:int;
		
		public function MongoDBRestEvent(type:String, data:Object=null, error:String=null, code:int=NaN, intbubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.data = data;
			this.error = error;
			this.code = code;
		}
	}
}