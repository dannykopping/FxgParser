package fxgparser.parser.style
{
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public interface IGradient 
	{
		function setSize( rect:Rectangle ):void;
		function get type():String;
		function get colors():Array;
		function get alphas():Array;
		function get ratios():Array;
		function get matrix():Matrix;
		function get method():String;
	}
	
}