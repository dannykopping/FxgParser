package fxgparser.parser.model 
{
	import flash.display.DisplayObjectContainer ;
	import flash.display.DisplayObject;
	import fxgparser.parser.style.Style;
	import fxgparser.parser.FxgFactory;
	
	public class Data
	{
		private var _currentXML:XML;
		private var _currentCanvas:DisplayObjectContainer;
		private var _persistent:PersistentData;
		
		public function Data(	xml:XML, canvas:DisplayObjectContainer , 
								persistent:PersistentData = null ) 
		{
			_persistent = persistent != null ? persistent : new PersistentData();
			_persistent.addData( this );
			_currentXML = _persistent.rootXML =  xml;
			_currentCanvas = _persistent.rootCanvas = canvas;
		}
		
		//return new Data with persistent data intact
		public function copy( xml:XML = null , canvas:DisplayObjectContainer = null):Data	
		{	
			if ( !xml ) xml = _currentXML;
			if ( !canvas ) canvas = _currentCanvas;
			return new Data( xml, canvas, _persistent );
		}
		
		public function get xml():XML { return _persistent.rootXML; }
		public function get canvas():DisplayObjectContainer { return _persistent.rootCanvas; }
		
		public function get currentCanvas():DisplayObjectContainer  { return _currentCanvas; }
		public function set currentCanvas( value:DisplayObjectContainer ):void {
			_currentCanvas = value;
		}
		public function get currentXml():XML { return _currentXML; }
		public function set currentXml( value:XML ):void {
			_currentXML = value;
		}
		
		public function clear():void 
		{
			_currentXML = null;
			_currentCanvas = null;
		}
	}

}