package fxgparser.parser.style 
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.EventDispatcher;
	import fxgparser.parser.utils.GeomUtil;
	import fxgparser.parser.utils.StyleUtil;
	import fxgparser.parser.Constants;

	public class BitmapFill extends EventDispatcher implements IStyleParser
	{
		public static var LOCALNAME:String = "BitmapFill";
		
		protected var loader:Loader;
		
		protected var _x:Number=0;
		protected var _y:Number=0;
		protected var _scaleX:Number = 1;
		protected var _scaleY:Number = 1;
		protected var _rotation:Number = 0;
		protected var _fillMode:String = "scale";
		protected var _href:String;
		
		protected var _matrix:Matrix = new Matrix();
		protected var _bitmapdata:BitmapData;
		protected var _loading:Boolean;
		
		public function BitmapFill() {}
		public function parse( item:XML ):void 
		{
			_x = StyleUtil.validateAttr( item.@x, _x );
			_y = StyleUtil.validateAttr( item.@y, _y );
			_scaleX = StyleUtil.validateAttr( item.@scaleX, _scaleX );
			_scaleY = StyleUtil.validateAttr( item.@scaleY, _scaleY );
			_rotation = StyleUtil.validateAttr( item.@rotation, _rotation );
			_fillMode = StyleUtil.validateAttr( item.@fillMode, _fillMode );
	
			_matrix.scale( _scaleX, _scaleY );
			_matrix.rotate( GeomUtil.degree2radian( _rotation ) );	
			_matrix.translate( _x , _y );	
			
			var fxg:Namespace = Constants.fxg;
			if ( item..fxg::Matrix.length() )
			{
				var m:XML = item..fxg::Matrix[0];
				_matrix = new Matrix();
				StyleUtil.validateMatrix( m, _matrix );
			}

			_href = StyleUtil.toURL( item.@source );
			if ( _href ) loadBitmap( _href );
		}
		
		public function setSize( rect:Rectangle ):void
		{
			if ( fillMode == "scale" )
			{
				_matrix = new Matrix();
				_matrix.scale( rect.width / _bitmapdata.width  , rect.height / _bitmapdata.height  );
				_matrix.translate( _x , _y );	
			}
		}
		
		protected function loadBitmap( url:String ):void
		{
			_loading = true;
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, loadComplete );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, loadError );
			loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, loadError );
			loader.load( new URLRequest( _href ) );
		}
		
		protected function loadComplete( e:Event ):void 
		{
			_loading = false;
			_bitmapdata = new BitmapData( loader.content.width, loader.content.height );
			_bitmapdata.draw( loader.content );
			
			dispatchEvent( new Event( Event.COMPLETE ) );

			loader.unload();
			removeListeners();
		}
		
		protected function loadError( e:Event ):void
		{
			_loading = false;
			dispatchEvent( new Event( Event.CANCEL ) );
			dispatchEvent( new Event( Event.COMPLETE ) );
			removeListeners();
		}
		
		protected function removeListeners():void
		{
			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, loadComplete );
			loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, loadError );
			loader.contentLoaderInfo.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, loadError );
		}
		
		public function get colorType():int { return ColorType.BITMAP; }
		public function get loading():Boolean { return _loading; }
		
		public function get repeat():Boolean { return _fillMode == "repeat"; }
		public function get fillMode():String { return _fillMode; }
		
		public function get bitmapdata():BitmapData { return _bitmapdata; }
		public function get matrix():Matrix { return _matrix.clone(); }
		
		

	}

}