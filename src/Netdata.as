package
{
	import com.sociodox.utils.Base64;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;

	public class Netdata extends EventDispatcher
	{
		private var _self:Object=this;
		private var ___headerList:Array=new Array();
		private var ___data:Object;
		private var ___filename:String;
		private var ___endpoint:String;
	
		public function Netdata()
		{
			//TODO : 網路有關
		}

		

		public function get endpoint():String
		{
			return ___endpoint;
		}

		public function set endpoint(value:String):void
		{
			___endpoint = value;
		}

		public function get filename():String
		{
			return ___filename;
		}

		public function set filename(value:String):void
		{
			___filename = value;
		}

		public function get datasource():Object
		{
			return ___data;
		}

		public function set datasource(value:Object):void
		{
			___data = value;
		}

		public function get headerList():Array
		{
			return ___headerList;
		}

		public function set headerList(value:Array):void
		{
			___headerList = value;
		}
		
		public function upload():void{
		
			
			var request:URLRequest=new URLRequest(this.___endpoint);
			
			//var headerItem:Object={name:"GG",value:"YY"};
			//___headerList.push(headerItem);
			
			
	
			//use mutipart
			var form:MsMultiPartFormData=new MsMultiPartFormData(); 
			form.AddFormField("filename",filename); 
			form.AddStreamFile("data",filename,ByteArray(this.___data)); 
			form.PrepareFormData(); 
			
			var partheader:URLRequestHeader = new URLRequestHeader ("Content-Type", "multipart/form-data; boundary="+form.Boundary); 
			request.requestHeaders.push(partheader);
			//import custom header
			for(var g:uint=0;g<___headerList.length; g++){
				var h:URLRequestHeader = new URLRequestHeader(Object(___headerList[g]).name, Object(___headerList[g]).value);
				request.requestHeaders.push(h);
			}
			
			
			
			
			request.method = URLRequestMethod.POST;
 
			request.data = form.GetFormData();  
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR,function err(e:IOErrorEvent):void{
				trace("error");
				_self.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
			});
			loader.addEventListener(Event.COMPLETE,function comp(ld:Event):void{
				ld.target.removeEventListener(Event.COMPLETE,comp)
				request.data=null;
				_self.dispatchEvent(new Event(Event.COMPLETE));
			})
			loader.load(request);
			
		}


	}
}