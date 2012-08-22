package soundshare.sdk.data.servers
{
	import soundshare.sdk.data.base.DataObject;
	
	[Bindable]
	public class ServerData extends DataObject
	{
		public var _id:String;
		public var accountId:String;
		public var secureId:String;
		
		public var token:String;
		
		public var address:String;
		public var port:int;
		
		public var name:String;
		public var type:int = 0;
		
		public var online:Boolean = false;
		
		public function ServerData()
		{
			super();
		}
		
		public function clear():void
		{
			_id = null;
			accountId = null;
			secureId = null;
			token = null;
			address = null;
			port = NaN;
			name = null;
			type = 0;
			online = false;
		}
		
		public function get publicData():Object
		{
			return {
				address: address,
				port: port,
				token: token
			};
		}
	}
}