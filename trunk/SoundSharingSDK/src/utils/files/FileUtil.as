package utils.files
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.CompressionAlgorithm;
	import flash.utils.getTimer;

	public class FileUtil
	{
		public function FileUtil()
		{
		}
		
		static public function saveObjectToStorageDirectory(filepath:String, object:Object):void
		{
			var t:Number = getTimer();
			var ba:ByteArray = new ByteArray();
			ba.writeObject(object);
			
			var cacheFile:File = File.applicationStorageDirectory.resolvePath(filepath);
			var stream:FileStream = new FileStream();
			stream.open(cacheFile, FileMode.WRITE);
			stream.writeBytes(ba);
			stream.close();
		}
		
		static public function loadObjectFromStorageDirectory(filepath:String):Object
		{
			var file:File = File.applicationStorageDirectory.resolvePath(filepath);
			var obj:Object;
			
			if (file.exists) 
			{
				var fileStream:FileStream = new FileStream();
				fileStream.open(file, FileMode.READ);
				obj = fileStream.readObject();
				fileStream.close();
			}
			
			return obj;
		}
		
		static public function removeFileFromStorageDirectory(filepath:String):void
		{
			var file:File = File.applicationStorageDirectory.resolvePath(filepath);
			
			if (file.exists)
				file.deleteFile();
		}
		
		static public function removeFilesFromStorageDirectory(path:String):void
		{
			var file:File = File.applicationStorageDirectory.resolvePath(path);
			
			if (file.exists) 
			{
				file.deleteDirectory(true);
				file.createDirectory();
			}
		}
	}
}