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
		
		public function parse( data:Data ):void {}
	}

}