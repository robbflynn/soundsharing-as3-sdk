package soundshare.sdk.db.mongo.servers
{
	import soundshare.sdk.db.mongo.base.MongoDBRest;
	
	public class ServersDataManager extends MongoDBRest
	{
		public function ServersDataManager(url:String=null)
		{
			super(url, "servers");
		}
	}
}