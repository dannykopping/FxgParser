package fxgparser.parser 
{
	import fxgparser.parser.model.Data;
	
	public interface IParser 
	{
		function parse(  data:Data ):void;
	}
	
}