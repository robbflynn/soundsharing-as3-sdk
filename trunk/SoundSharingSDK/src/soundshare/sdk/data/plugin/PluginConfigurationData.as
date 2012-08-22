package soundshare.sdk.data.plugin
{
	import soundshare.sdk.data.base.DataObject;

	public class PluginConfigurationData extends DataObject
	{
		public var pluginId:String;
		public var configuration:Object;
		
		public function PluginConfigurationData()
		{
		}
		
		override public function readObject(obj:Object, excep:Array = null):Boolean
		{
			if (super.readObject(obj, excep) && obj.configuration)
				configuration = obj.configuration;
			
			return true;
		}
		
		override public function clearObject():void
		{
			pluginId = null;
			configuration = null;
		}
		
		override public function get data():Object
		{
			return {
				pluginId: pluginId,
				configuration: configuration
			};
		}
	}
}