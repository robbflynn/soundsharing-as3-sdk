package soundshare.sdk.data.platlists
{
	import soundshare.sdk.data.base.DataObject;

	[Bindable]
	public class PlaylistContext extends DataObject
	{
		public var _id:String;
		public var accountId:String;
		public var stationId:String;
		
		public var name:String;
		public var info:String;
		public var genre:String;
		public var type:int;
		public var total:int = 0;
		
		public var groups:Array = new Array();
		
		public function PlaylistContext()
		{
		}
		
		override public function readObject(obj:Object, excep:Array = null):Boolean
		{
			excep = excep ? excep.concat(["groups"]) : ["groups"];
			
			if (!super.readObject(obj, excep))
				return false;
			
			if (obj.groups)
				groups = obj.groups;
			
			return true;
		}
		
		override public function get data():Object
		{
			return {
				accountId: accountId,
				stationId: stationId,
				name: name,
				info: info,
				genre: genre,
				type: type,
				total: total,
				groups: groups
			};
		}
	}
}