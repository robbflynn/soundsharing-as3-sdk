package utils.collection
{
	import mx.collections.ArrayCollection;

	public class CollectionUtil
	{
		public function CollectionUtil()
		{
		}
		
		static public function getItemFromCollection(property:String, value:Object, collection:ArrayCollection):Object
		{
			for (var i:int = 0;i < collection.length;i ++)
				if (collection.getItemAt(i)[property] == value)
					return collection.getItemAt(i);
			
			return null;
		}
		
		static public function getItemIndexFromCollection(property:String, value:Object, collection:ArrayCollection):int
		{
			for (var i:int = 0;i < collection.length;i ++)
				if (collection.getItemAt(i)[property] == value)
					return i;
			
			return -1;
		}
	}
}