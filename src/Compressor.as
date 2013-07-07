package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PNGEncoderOptions;
	import flash.display.PixelSnapping;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;

	public class Compressor extends EventDispatcher
	{
		private var _source:BitmapData;
		private var _rate:Number;
		private var _result:ByteArray=new ByteArray();
		private var _format:String;
		private var _formatalgorithm:Object
		public function Compressor()
		{
			
		}

		public function get format():String
		{
			return _format;
		}

		public function set format(value:String):void
		{
			if(value.toString().toLocaleUpperCase()=="JPG"){
				_formatalgorithm=new flash.display.JPEGEncoderOptions();
			}else if(value.toString().toLocaleUpperCase()=="PNG"){
				_formatalgorithm=new flash.display.PNGEncoderOptions();
			}
			_format = value;
		}

		public function start():void{
		var ori:BitmapData=BitmapData(this.source)
		
		var scale:Number = _rate;
		var matrix:Matrix = new Matrix();
		matrix.scale(scale, scale);
		
		var smallBMD:BitmapData = new BitmapData(ori.width * scale, ori.height * scale, true, 0x000000);
		smallBMD.draw(ori, matrix, null, null, null, true);
		
		//var bitmap:Bitmap = new Bitmap(smallBMD, PixelSnapping.NEVER, true);
		ori.dispose();
		smallBMD.encode(smallBMD.rect, _formatalgorithm, this.result);
		}
		public function get result():ByteArray
		{
			return _result;
		}
		
		public function set result(value:ByteArray):void
		{
			_result = value;
		}

		public function get rate():Number
		{
			return _rate;
		}

		public function set rate(value:Number):void
		{
			_rate = value;
		}

		public function get source():BitmapData
		{
			return _source;
		}

		public function set source(value:BitmapData):void
		{
			_source = value;
		}

	}
}