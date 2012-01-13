package org.libspark.fxgparser.parser
{
	import flash.display.DisplayObject;
	import org.libspark.fxgparser.parser.IParser;
	import org.libspark.fxgparser.parser.model.Data;
	import org.libspark.fxgparser.parser.style.Style;
	import flash.display.Sprite;

	public class Library implements IParser
	{
		public static var LOCALNAME:String = "Library";
		
		public function Library() { }
		
		public function parse( data:Data ):void {}
	}

}