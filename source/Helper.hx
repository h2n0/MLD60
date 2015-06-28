package source;
import source.entitys.Populite;
import flixel.FlxSprite;
/**
 * ...
 * @author Elliot Lee-Cerrino
 */
class Helper
{

	public static function getAngle(x1:Float, y1:Float, x2:Float, y2:Float):Float {	
		var x3:Float = x1 - x2;
		var y3:Float = y1 - y2;
		return Math.atan2(y3, x3);
	}
	
	public static function getStraightLineDist(x1:Float,y1:Float,x2:Float,y2:Float):Float {
		var x3:Float = Math.pow(x1 - x2,2);
		var y3:Float = Math.pow(y1 - y2,2);
		return Math.sqrt(x3 + y3);
	}
	
	public static var selectedPop:Populite = null;
	
}