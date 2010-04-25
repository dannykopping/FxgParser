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
		
		private var _x:Number;
		private var _y:Number;
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
			
			_x = _style.x = StyleUtil.toNumber( data.currentXml.@x );
			_y = _style.y = StyleUtil.toNumber( data.currentXml.@y );
			_width = _style.width = StyleUtil.toNumber( data.currentXml.@width );
			_height = _style.height = StyleUtil.toNumber( data.currentXml.@height );

			_href = StyleUtil.toURL( data.currentXml.@source );

			if ( _href != null ) loadImage();
		}
		
		protected function loadImage():void 
		{
			var loader:Loader = new Loader();
			loader.name = _style.id;
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadComplete );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, loadError );
			loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, loadError );
			loader.load( new URLRequest( _href ) );
			_data.currentCanvas.addChild( loader );
		}
		
		protected function loadComplete( e:Event ):void 
		{
			var loader:Loader = e.currentTarget.loader as Loader;
			loader.x = _x;
			loader.y = _y;
			_style.applyStyle( loader.content , false );
			_data = null;
			_style = null;
			
			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, loadComplete );
			loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, loadError );
			loader.contentLoaderInfo.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, loadError );
		}
		
		protected function loadError( e:Event ):void{}
	}

}