package soundshare.sdk.builders.db.mongo.accounts
{
	import soundshare.sdk.db.mongo.accounts.AccountsDataManager;

	public class AccountsDataManagersBuilder
	{
		protected var cache:Vector.<AccountsDataManager> = new Vector.<AccountsDataManager>();
		
		public var cacheEnabled:Boolean = true;
		
		public function AccountsDataManagersBuilder()
		{
		}
		
		public function build():AccountsDataManager
		{
			var manager:AccountsDataManager;
			
			if (cacheEnabled)
				manager = cache.shift();
			
			if (!manager)
				manager = new AccountsDataManager();
			
			return manager;
		}
		
		public function destroy(manager:AccountsDataManager):void
		{
			manager.close();
			
			if (cacheEnabled)
				cache.push(manager);
		}
	}
}