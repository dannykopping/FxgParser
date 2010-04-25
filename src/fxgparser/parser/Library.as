package fxgparser.parser 
{
	import flash.display.DisplayObject;
	import fxgparser.parser.IParser;
	import fxgparser.parser.model.Data;
	import fxgparser.parser.style.Style;
	import flash.display.Sprite;

	public class Library implements IParser
	{
		public static var LOCALNAME:String = "Library";
		
		public function Library() { }
		
		public function parse( data:Data ):void {
			var style:Style = new Style( data.currentXml );
			var group:Sprite = new Sprite();
			group.name = style.id;
			style.applyStyle( group );
			var groupXML:XML = data.currentXml.copy();
			groupXML.setLocalName(  "_defs" );	
			FxgFactory.parseData( data.copy( groupXML, group ) );
			group = null;
		}
	}

}