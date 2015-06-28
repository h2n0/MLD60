package source.world;

import flixel.FlxSprite;
import source.world.Resource.Res;

import source.world.Container;
/**
 * ...
 * @author Elliot Lee-Cerrino
 */
class Tree extends Container
{

	public function new(x:Float,y:Float) 
	{
		super(x, y);
		this.x = x;
		this.y = y;
		this.drop = new Resource(x, y, Res.wood, Math.floor(Math.random() * 4) + 1);
		this.makeGraphic(10, 60, 0xFFCCCC00);
		this.health = 100;
	}
	
}