package soundshare.sdk.db.mongo.stations
{
	import soundshare.sdk.db.mongo.base.MongoDBRest;
	
	public class StationsDataManager extends MongoDBRest
	{
		public function StationsDataManager(url:String=null)
		{
			super(url, "stations");
		}
	}
}