package fxgparser.parser 
{
	import flash.display.Sprite;
	import fxgparser.parser.IParser;
	import fxgparser.parser.model.Data;
	import fxgparser.parser.style.Style;
	import fxgparser.parser.utils.StyleUtil;
	
	public class Group implements IParser
	{
		
		public static var LOCALNAME:String = "Group";
		
		private var _x:Number;
		private var _y:Number;
		private var _width:Number;
		private var _height:Number;
		
		public function Group() {}

		public function parse( data:Data ):void 
		{
			var style:Style = new Style( data.currentXml );
			if ( !style.display ) return;
			var group:Sprite = new Sprite();
			group.name = style.id;
			
			_x = StyleUtil.toNumber( data.currentXml.@x );
			_y = StyleUtil.toNumber( data.currentXml.@y );
			_width = StyleUtil.toNumber( data.currentXml.@width );
			_height = StyleUtil.toNumber( data.currentXml.@height );

			data.currentCanvas.addChild( group );
			var groupXML:XML = data.currentXml.copy();
			groupXML.setLocalName(  "_Group" );	
			FxgFactory.parseData( data.copy( groupXML, group ) );
			
			if( _x != 0 )group.x = _x;
			if( _y != 0 )group.y = _y;
			if( _width != 0 ) group.width = _width;
			if( _height != 0 ) group.height = _height;
			
			style.applyStyle( group );
		}
	}

}