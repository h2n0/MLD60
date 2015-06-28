package source.world;


import flixel.FlxSprite;
/**
 * ...
 * @author Elliot Lee-Cerrino
 */

enum Res {
	wood;
	food;
	water;
	stone;
}

class Resource extends FlxSprite
{
	public var type:EnumValue;
	public var value:Int;
	
	public function new(x:Float, y:Float, t:EnumValue, val:Int) 
	{
		super(x, y);
		this.type = t;
		this.visible = false;
		this.value = val;
		
		if (t == Res.wood) this.makeGraphic(4, 4, 0xFFCCCC00);
		else if (t == Res.water) this.makeGraphic(4, 4, 0xFF770000);
		else if (t == Res.stone) this.makeGraphic(4, 4, 0xFFCCCCCC);
		else if (t == Res.food) this.makeGraphic(4, 4, 0xFFCC0000);
	}
	
}