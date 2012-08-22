package utils.math
{
	public class ExMath
	{
		public function ExMath()
		{
		}
		
		static public function uuidCompact():String
		{
			var s1:String = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx";
			var s2:String = "";
			var r:Number;
			var v:Number;
			
			for (var i:int = 0;i < s1.length;i ++)
				if (s1.charAt(i) == "x" || s1.charAt(i) == "y")
				{
					r = Math.random()*16 | 0;
					v = s1.charAt(i) == "x" ? r : (r&0x3|0x8);
					
					s2 += v.toString(16).toUpperCase();
				}
				else
					s2 += s1.charAt(i);
			
			return s2;
		}
	}
}