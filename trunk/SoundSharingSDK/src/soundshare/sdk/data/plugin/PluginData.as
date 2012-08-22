package soundshare.sdk.data.plugin
{
	import soundshare.sdk.data.base.DataObject;
	import soundshare.sdk.plugins.container.IPluginContainer;

	[Bindable]
	public class PluginData extends DataObject
	{
		// types: 0-playlist, 1-channel
		
		public var _id:String;
		public var name:String;
		public var namespace:String;
		public var type:int;
		public var filename:String;
		
		public var version:String;
		public var plugin:IPluginContainer;
		
		public function PluginData()
		{
		}
		
		override public function get data():Object
		{
			return {
				_id: _id,
				name: name,
				namespace: namespace,
				type: type,
				filename: filename,
				version: version
			};
		}
	}
}