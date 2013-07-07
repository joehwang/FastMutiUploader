package
{
	import filetype.ImageFile;
	import filetype.OtherFile;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;

	public class FastMutiUploader extends EventDispatcher
	{
		
		private var fileRefList:FileReferenceList=new FileReferenceList();
		private var filelist:Array;
		private var _compresstion:Boolean=true;
		public function FastMutiUploader()
		{
			
		}

		public function get compresstion():Boolean
		{
			return _compresstion;
		}

		public function set compresstion(value:Boolean):void
		{
			_compresstion = value;
		}

		public function selectLocalFiles():void{
			
			var imgTypeFilter:FileFilter = new FileFilter("GIF/JPG/PNG Files","*.jpeg; *.jpg;*.gif;*.png");
			fileRefList.addEventListener(Event.SELECT, onFileSelected);
			
			var allTypeFilter:FileFilter = new FileFilter("All Files (*.*)","*.*");
			fileRefList.browse([imgTypeFilter, allTypeFilter]);
		}
		private function onFileSelected(event:Event):void{
			var file:FileReference;
			filelist=fileRefList.fileList;
			//for (var i:uint = 0; i < filelist.length; i++)
			//{	
				file=FileReference(filelist[0])
				var uploadf:Object;
				if(isImage(file)==true && this._compresstion==true){
					uploadf=new ImageFile(file);
					
					//uploadf.maxLongside=50
				}else{
					uploadf=new OtherFile(file);
				}
				//TODO : 把NET從OtherFile 和 ImageFile 移出
				uploadf.addEventListener(Event.COMPLETE,onUploaded)
				uploadf.addEventListener(ProgressEvent.PROGRESS,onProgress)	
				uploadf.addEventListener(IOErrorEvent.IO_ERROR,onFileLoadError)
			//}   
		
		}
		//handler
		private function onUploaded(event:Event):void{
			trace("uploaded");
			filelist.shift();
			if (filelist.length!=0){
				onFileSelected(event)
			}
		}
		private function onFileLoadError(event:IOErrorEvent):void{
			trace("load error");
		}
		private function onProgress(e:ProgressEvent):void{
			trace("static file upload " + e.bytesLoaded + " out of " + e.bytesTotal + " bytes");		}
		
		private function isImage(file:FileReference):Boolean{
			var ext:String=String(file.name.split(".")[1]).toLocaleUpperCase();
			if(ext=="JPG" || ext=="PNG"){	
				return true;
			}else{
				return false;
			}
		}
	}
}
