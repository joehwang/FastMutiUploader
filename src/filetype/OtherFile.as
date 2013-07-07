package filetype
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;

	public class OtherFile extends EventDispatcher
	{
		private var __uploadProgress:uint;
		private var _self:Object;
		private var filename:String;
		private var dataref:FileReference;
		public function OtherFile(_fileref:FileReference)
		{
			_self=this;
			dataref=_fileref;
			filename=_fileref.name;
			_fileref.addEventListener(Event.COMPLETE, onFileLoaded);
			_fileref.addEventListener(IOErrorEvent.IO_ERROR, onFileLoadError);
			_fileref.addEventListener(ProgressEvent.PROGRESS, onFileLoadProgress);
			_fileref.load();
		}
		private function onFileLoaded(event:Event):void{
			event.target.removeEventListener(Event.COMPLETE,onFileLoaded)
			event.target.removeEventListener(IOErrorEvent.IO_ERROR,onFileLoadError)
			event.target.removeEventListener(ProgressEvent.PROGRESS,onFileLoadProgress)
			var net:Netdata=new Netdata();
			net.datasource=dataref.data;
			
			net.endpoint="http://uploader.dev/item/upload_mutipart"
			//net.endpoint="http://127.0.0.1:3000/item/upload_mutipart"
			net.filename=filename;
			net.headerList=new Array();
			net.upload();
			net.addEventListener(Event.COMPLETE,function comp(ld:Event):void{
				
				ld.target.removeEventListener(Event.COMPLETE,comp)
				//request.data=null
				//byteArray=null
				
				
				_self.dispatchEvent(new Event(Event.COMPLETE));
			})
		}
		private function onFileLoadError(e:IOErrorEvent):void{
			_self.dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
			
		}
		private function onFileLoadProgress(e:ProgressEvent):void{
			
			_self.dispatchEvent(ProgressEvent(e));
			//trace("static file upload " + e.bytesLoaded + " out of " + e.bytesTotal + " bytes");
		}
	}
}