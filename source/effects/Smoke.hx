package source.effects;

import flixel.FlxSprite;
import AssetPaths;
/**
 * ...
 * @author Elliot Lee-Cerrino
 */
class Smoke extends FlxSprite
{

	public function new(x:Float,y:Float) 
	{
		super(x, y);
		this.loadGraphic(AssetPaths.smoke__png, true, 5, 5);
		this.color = (Math.random() > 0.5) ? 0xFFCCCCCC : 0xFF777777;
		this.health = 50 + Math.ffloor(Math.random() * 30);
	}
	
	override public function update():Void {
		super.update();
		this.y -= 0.5;
		if (--this.health == 0) this.destroy();
		
	}
	
}