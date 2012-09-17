package soundshare.sdk.plugins.collection
{
	import soundshare.sdk.data.plugin.PluginData;
	import soundshare.sdk.plugins.container.IPluginContainer;

	public class PluginsCollection
	{
		private var pluginsById:Array = new Array();
		private var pluginsByFilename:Array = new Array();
		private var plugins:Vector.<PluginData> = new Vector.<PluginData>();
		
		public function PluginsCollection()
		{
		}
		
		public function addPlugin(pluginData:PluginData):void
		{
			pluginsById[pluginData._id] = pluginData;
			pluginsByFilename[pluginData.filename] = pluginData;
			
			plugins.push(pluginData);
		}
		
		public function removePlugin(id:String):void
		{
			if (pluginsById[id])
			{
				var pd:PluginData = pluginsById[id] as PluginData;
				var index:int = plugins.indexOf(pd);
				
				plugins.splice(index, 1);
				
				delete pluginsById[id];
				delete pluginsByFilename[pd.filename]
			}
		}
		
		public function getPluginById(id:String):PluginData
		{
			return pluginsById[id];
		}
		
		public function getPluginByFilename(filename:String):PluginData
		{
			return pluginsByFilename[filename];
		}
		
		public function getPluginAt(index:int):PluginData
		{
			return plugins[index];
		}
		
		public function removeAll():void
		{
			pluginsById = new Array();
			pluginsByFilename = new Array();
			
			while (plugins.length > 0)
				plugins.shift();
		}
		
		public function get collection():Array
		{
			var a:Array = new Array();
			var len:int = plugins.length;
			
			for (var i:int = 0;i < len;i ++)
				a.push(plugins[i])
			
			return a;
		}
		
		public function get length():int
		{
			return plugins.length;
		}
	}
}