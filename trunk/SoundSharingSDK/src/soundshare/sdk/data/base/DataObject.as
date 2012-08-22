package soundshare.sdk.data.base
{
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class DataObject
	{
		protected var primitives:Array = ["String", "Number", "int", "uint", "Boolean"];
		
		public function DataObject()
		{
		}
		
		public function readObject(obj:Object, excep:Array = null):Boolean
		{
			if (!obj)
				return false;
			
			if (!excep)
				excep = new Array();
			
			for (var key:String in obj)
				if ((excep.indexOf(key) == -1) && hasOwnProperty(key) && isPrimitive(obj[key]))
					this[key] = obj[key];
			
			var describedObj:Object = describeType(this);
			var xmlVar:XML;
			
			for each(xmlVar in describedObj.variable)
				if ((excep.indexOf(String(xmlVar.@name)) == -1) && hasOwnProperty(xmlVar.@name) && isPrimitive(obj[xmlVar.@name]))
					this[xmlVar.@name] = obj[xmlVar.@name];
				
			for each(xmlVar in describedObj.accessor)
				if ((excep.indexOf(String(xmlVar.@name)) == -1) && hasOwnProperty(xmlVar.@name) && isPrimitive(obj[xmlVar.@name]))
					this[xmlVar.@name] = obj[xmlVar.@name];
				
			return true;
		}
		
		public function clearObject():void
		{
			
		}
		
		protected function isPrimitive(value:Object):Boolean
		{
			return primitives.indexOf(getQualifiedClassName(value)) != -1;
		}
		
		public function get data():Object
		{
			return null;
		}
	}
}