package source.world;

import flixel.FlxSprite;
import source.world.Resource.Res;

import source.world.Container;
import AssetPaths;
/**
 * ...
 * @author Elliot Lee-Cerrino
 */
class Tree extends Container
{

	private var deathTimer:Int;
	public function new(x:Float,y:Float) 
	{
		super(x, y);
		this.x = x;
		this.y = y;
		this.drop = genDrop();
		this.loadGraphic(AssetPaths.Tree__png);
		this.health = 100;
		this.deathTimer = 60 * 100;
	}
	
	public function genDrop():Resource {
		return new Resource(this.x, this.y, Res.wood, Math.floor(Math.random() * 4) + 1);
	}
	
	override public function update():Void {
		super.update();
		if (this.health <= 0) {
			this.alive = false;
		}
		if (!this.alive){
			if (--this.deathTimer == 0) this.destroy();
		}
	}
	
}