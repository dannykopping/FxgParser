package fxgparser.parser
{
	import flash.display.DisplayObjectContainer ;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import fxgparser.parser.IParser;
	import fxgparser.parser.model.Data;
	import fxgparser.parser.Constants;
	import fxgparser.parser.style.Style;
	import fxgparser.parser.utils.StyleUtil;
	
	public class BitmapGraphic implements IParser
	{
		public static var LOCALNAME:String = "BitmapGraphic";
		
		protected var loader:Loader;
		
		private var _width:Number;
		private var _height:Number;
		private var _href:String;
		private var _binaryData:String;
		
		private var _imageWidth:Number;
		private var _imageHeight:Number;
		
		private var _data:Data;
		private var _style:Style;

		public function BitmapGraphic() {}
		
		public function parse( data:Data ):void 
		{
			_style = new Style( data.currentXml );
			_data = data;
			
			_width = _style.width;
			_height = _style.height;

			_href = StyleUtil.toURL( data.currentXml.@source );

			if ( _href != null ) loadImage();
		}
		
		protected function loadImage():void 
		{
			loader = new Loader();
			loader.name = _style.id;
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadComplete );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, loadError );
			loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, loadError );
			loader.load( new URLRequest( _href ) );
			_data.currentCanvas.addChild( loader );
		}
		
		protected function loadComplete( e:Event ):void 
		{
			_style.applyStyle( loader.content );
			removeListeners();
		}
		
		protected function loadError( e:Event ):void { removeListeners(); }
		
		protected function removeListeners():void
		{
			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, loadComplete );
			loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, loadError );
			loader.contentLoaderInfo.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, loadError );
			_data = null;
			_style = null;
		}
	}

}