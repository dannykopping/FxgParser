package fxgparser.parser.model 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
		
	public class PersistentData
	{
		private var _rootXML:XML;
		private var _rootCanvas:DisplayObjectContainer;
		private var _datas:Array = [];
		
		public function PersistentData() {}
				
		public function get rootXML():XML { return _rootXML; }
		public function set rootXML(value:XML):void 
		{
			if ( !_rootXML ) _rootXML = value;
		}
		
		public function get rootCanvas():DisplayObjectContainer { return _rootCanvas; }
		public function set rootCanvas(value:DisplayObjectContainer):void 
		{
			if( !_rootCanvas ) _rootCanvas = value;
		}
		
		public function addData( data:Data ):void 
		{
			for each( var d:Data in _datas ) 
				if ( d == data ) return;
			_datas.push( data );
		}
		
		public function reset():void 
		{
			_rootXML = null;
			_rootCanvas = null;
			for each( var d:Data in _datas ) 
				d.clear();
			_datas = null;
		}

	}

}