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
		
		private var _width:Number;
		private var _height:Number;
		
		public function Group() {}

		public function parse( data:Data ):void 
		{
			var style:Style = new Style( data.currentXml );
			if ( !style.display ) return;
			var group:Sprite = new Sprite();
			group.name = style.id;
			
			group.width = _width = style.width;
			group.height = _height = style.height;

			data.currentCanvas.addChild( group );
			var groupXML:XML = data.currentXml.copy();
			groupXML.setLocalName(  "_Group" );	
			FxgFactory.parseData( data.copy( groupXML, group ) );
			
			style.applyStyle( group );
		}
	}

}