package soundshare.sdk.data.track
{
	import soundshare.sdk.data.base.DataObject;

	[RemoteClass]
	public class TrackData extends DataObject
	{
		public var accountId:String;
		public var stationId:String;
		
		public var path:String;
		
		public function TrackData()
		{
		}
	}
}