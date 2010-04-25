package fxgparser.parser.style
{
	
	public interface IStyleParser 
	{
		function parse( item:XML ):void;
		function get colorType():int;
	}
	
}