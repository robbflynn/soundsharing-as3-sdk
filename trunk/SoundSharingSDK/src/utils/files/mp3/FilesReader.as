package utils.files.mp3
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.utils.getTimer;
	
	import utils.files.mp3.item.FilesReaderItem;
	
	public class FilesReader extends EventDispatcher
	{
		private var filesList:Array;
		private var items:Array;
		private var currentItems:Array;
		
		public var ownerId:String;
		public var extensions:Array;
		
		public function FilesReader(ownerId:String = "", extensions:Array = null)
		{
			super();
			
			this.ownerId = ownerId;
			this.extensions = extensions;
			
			filesList = new Array();
			
			items = new Array();
			currentItems = new Array();
		}
		
		private var t:uint;
		
		public function read(directory:File):void
		{
			t = getTimer();
			
			directory.getDirectoryListingAsync();
			directory.addEventListener(FileListEvent.DIRECTORY_LISTING, onDirectoryListing);
		}
		
		private function onDirectoryListing(event:FileListEvent):void 
		{
			var list:Array = event.files;
			var file:File;
			var item:FilesReaderItem;
			
			for (var i:uint = 0; i < list.length;i ++) 
			{
				file = list[i] as File;
				
				if (file.isDirectory)
				{
					item = new FilesReaderItem(file, items, directoryComplete, ownerId, extensions);
					currentItems.push(item);
				}
				else
				if (!extensions || extensions.indexOf(file.extension) != -1)
					filesList.push(file);
			}
			
			directoryComplete();
			
			//trace("filesList:", filesList);
		}
		
		private function directoryComplete():void
		{
			//trace("items:", items.length);
			
			if (items.length == 0)
				dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function clear():void
		{
			filesList = new Array();
			
			items = new Array();
			currentItems = new Array();
		}
		
		public function get files():Array
		{
			var arr:Array = new Array();
			arr = arr.concat(filesList);
			
			for (var i:int = 0;i < currentItems.length;i ++)
				arr = arr.concat((currentItems[i] as FilesReaderItem).files);
			
			return arr;
		}
		
		public function get filesPaths():Array
		{
			var arr:Array = new Array();
			var i:int;
			
			for (i = 0;i < filesList.length;i ++)
				arr.push({path: (filesList[i] as File).nativePath, ownerId: ownerId});
			
			for (i = 0;i < currentItems.length;i ++)
				arr = arr.concat((currentItems[i] as FilesReaderItem).filesPaths);
			
			return arr;
		}
	}
}