package filetype
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	public class ImageFile extends EventDispatcher 
	{
		private var __conpresstion:Boolean;
		private var __uploadProgress:uint;
		private var _self:Object;
		private var _maxLongside:uint=0;
		private var filename:String;
		public function ImageFile(_fileref:FileReference)
		{
			_self=this;
			filename=_fileref.name;
			_fileref.addEventListener(Event.COMPLETE, onFileLoaded);
			_fileref.addEventListener(IOErrorEvent.IO_ERROR, onFileLoadError);
			_fileref.addEventListener(ProgressEvent.PROGRESS, onFileLoadProgress);
			_fileref.load();	
		}
		//handler

		public function get maxLongside():uint
		{
			return _maxLongside;
		}

		public function set maxLongside(value:uint):void
		{
			_maxLongside = value;
		}

		public function get uploadProgress():uint
		{
			return __uploadProgress;
		}

		public function get conpresstion():Boolean
		{
			return __conpresstion;
		}

		public function set conpresstion(value:Boolean):void
		{
			__conpresstion = value;
		}

		private function onFileLoaded(event:Event):void{
			event.target.removeEventListener(Event.COMPLETE,onFileLoaded)
			event.target.removeEventListener(IOErrorEvent.IO_ERROR,onFileLoadError)
			event.target.removeEventListener(ProgressEvent.PROGRESS,onFileLoadProgress)
			var img:Loader=new Loader();
			img.loadBytes(event.target.data);
			img.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadByteComplete);
		}
		private function cal_resizerate(_ow:Number,_oh:Number):Number{
			var r:Number=0;
			if(this._maxLongside==0){
				r=1;
			}else{
				var longs:Number=(_ow>_oh)?_ow:_oh;
				r=(longs>this._maxLongside)?this._maxLongside/longs:1;
			}
			
			return r;
		}
		private function onLoadByteComplete(e:Event):void{
			e.target.removeEventListener(Event.COMPLETE,onLoadByteComplete)
		
			var zipImage:Compressor=new Compressor();
				zipImage.source=Bitmap(e.target.content).bitmapData;
				zipImage.rate=cal_resizerate(Bitmap(e.target.content).width,Bitmap(e.target.content).height);
				zipImage.format="JPG"
				zipImage.start();
		
			var net:Netdata=new Netdata();
				net.datasource=zipImage.result;
				
				net.endpoint="http://uploader.dev/item/upload_mutipart"
				net.filename=filename;
				net.headerList=new Array();
				net.upload();
		
			net.addEventListener(Event.COMPLETE,function comp(ld:Event):void{
				
				ld.target.removeEventListener(Event.COMPLETE,comp)
				//request.data=null
				//byteArray=null
				
				//BitmapData(e.target.content).dispose();
				//bp.bitmapData.dispose();
				LoaderInfo(e.target).loader.unload();
				_self.dispatchEvent(new Event(Event.COMPLETE));
			})
			
		}
		private function onFileLoadError(e:IOErrorEvent):void{
			_self.dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
			
		}
		private function onFileLoadProgress(e:ProgressEvent):void{
		
			_self.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
			//trace("image file upload " + e.bytesLoaded + " out of " + e.bytesTotal + " bytes");
		}
		
	}
}