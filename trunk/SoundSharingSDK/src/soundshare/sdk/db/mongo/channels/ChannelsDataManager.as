package soundshare.sdk.db.mongo.channels
{
	import soundshare.sdk.db.mongo.base.MongoDBRest;
	
	public class ChannelsDataManager extends MongoDBRest
	{
		public function ChannelsDataManager(url:String=null)
		{
			super(url, "channels");
		}
	}
}