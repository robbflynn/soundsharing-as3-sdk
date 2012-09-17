package utils.date
{
	public class DateUtil
	{
		public function DateUtil()
		{
		}
		
		public static function parseToDate(value:String):Date
		{
			var dateTime:Array = value.split(" ");
			dateTime = (dateTime[0].split("-") as Array).concat(dateTime[1].split(":"));
			
			return new Date(dateTime[0], int(dateTime[1]) - 1, dateTime[2], dateTime[3], dateTime[4], dateTime[5]);
		}
		
		public static function parseToString(value:Date, fullDatetime:Boolean = true):String
		{
			if (!fullDatetime)
				return value.getFullYear() + "-" + 
					  (value.getMonth() < 9 ? "0" + (value.getMonth() + 1) : (value.getMonth() + 1)) + "-" +
					  (value.getDate() < 10 ? "0" + value.getDate() : value.getDate());
				
			return value.getFullYear() + "-" + 
				  (value.getMonth() < 9 ? "0" + (value.getMonth() + 1) : (value.getMonth() + 1)) + "-" +
				  (value.getDate() < 10 ? "0" + value.getDate() : value.getDate()) + " " +
				  (value.getHours() < 10 ? "0" + value.getHours() : value.getHours()) + ":" +
				  (value.getMinutes() < 10 ? "0" + value.getMinutes() : value.getMinutes()) + ":" +
				  (value.getSeconds() < 10 ? "0" + value.getSeconds() : value.getSeconds());
		}
	}
}