package utils.files.folder
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.utils.getTimer;
	
	import utils.files.folder.item.FolderFilesReaderItem;
	
	public class FolderFilesReader extends EventDispatcher
	{
		private var filesList:Array;
		private var items:Array;
		private var currentItems:Array;
		
		public var extensions:Array;
		
		public function FolderFilesReader(extensions:Array = null)
		{
			super();
			
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
			var item:FolderFilesReaderItem;
			
			for (var i:uint = 0; i < list.length;i ++) 
			{
				file = list[i] as File;
				
				if (file.isDirectory)
				{
					item = new FolderFilesReaderItem(file, items, directoryComplete, extensions);
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
				arr = arr.concat((currentItems[i] as FolderFilesReaderItem).files);
			
			return arr;
		}
		
		public function get filesPaths():Array
		{
			var arr:Array = new Array();
			var i:int;
			
			for (i = 0;i < filesList.length;i ++)
				arr.push((filesList[i] as File).nativePath);
			
			for (i = 0;i < currentItems.length;i ++)
				arr = arr.concat((currentItems[i] as FolderFilesReaderItem).filesPaths);
			
			return arr;
		}
	}
}