package utils.files.mp3.item
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FileListEvent;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	
	public class FilesReaderItem extends EventDispatcher
	{
		private var filesList:Array;
		
		private var items:Array;
		private var currentItems:Array;
		
		private var directoryComplete:Function;
		
		public var ownerId:String;
		public var extensions:Array;
		
		public function FilesReaderItem(directory:File, items:Array, directoryComplete:Function, ownerId:String = "", extensions:Array = null)
		{
			super();
			
			this.items = items;
			this.items.push(this);
			
			this.currentItems = new Array();
			
			this.directoryComplete = directoryComplete;
			this.filesList = new Array();
			
			this.ownerId = ownerId;
			this.extensions = extensions;
			
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
					item = new FilesReaderItem(file, items, directoryComplete, ownerId);
					currentItems.push(item);
				}
				else
				if (!extensions || extensions.indexOf(file.extension) != -1)
					filesList.push(file);
			}
			
			var index:uint = items.indexOf(this);
			items.splice(index, 1);
			
			directoryComplete();
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