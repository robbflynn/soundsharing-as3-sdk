package socket.json
{
	public class JSONFacade
	{
		public static var parseFn:Function;
		public static var stringifyFn:Function;
		
		public function JSONFacade()
		{
		}
		
		public static function parse(value:String):Object
		{
			return parseFn(value);
		}
		
		public static function stringify(value:Object):String
		{
			return stringifyFn(value);
		}
	}
}