package utils.cache
{
	import flash.utils.getQualifiedClassName;
	
	import mx.rpc.events.AbstractEvent;
	
	public class CacheFactory
	{
		private var _objects:Object = new Object();
		
		public function CacheFactory()
		{
		}
		
		public function push(item:Object):void
		{
			if (!item)
				return ;
			
			var cn:String = getQualifiedClassName(item); 
			
			if (!_objects[cn])
				_objects[cn] = new Vector.<Object>();
			
			(_objects[cn] as Vector.<Object>).push(item);
		}
		
		public function pull(calssName:Object):Object
		{
			var cn:String = getName(calssName);
			
			if (!cn)
				return null;
			
			var a:Vector.<Object> = _objects[cn] as Vector.<Object>;
			
			if (!a || a.length == 0)
				return null;
			
			return a.shift();
		}
		
		public function exist(calssName:Object):Boolean
		{
			var cn:String = getName(calssName);
			
			if (!cn)
				return false;
			
			var a:Vector.<Object> = _objects[cn] as Vector.<Object>;
			
			return a && a.length > 0;
		}
		
		private function getName(value:Object):String
		{
			if (!value || value == "")
				return null;
			
			if (value is String)
				return value as String;
			else
				return getQualifiedClassName(value);
			
			return null;
		}
	}
}