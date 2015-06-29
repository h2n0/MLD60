package source.entitys;

import flixel.FlxSprite;
import AssetPaths;
import flixel .FlxG;
import source.effects.Smoke;
/**
 * ...
 * @author Elliot Lee-Cerrino
 */
class Ship extends FlxSprite
{

	private var ty:Float;
	public function new() 
	{
		super(-100, -100);
		this.loadGraphic(AssetPaths.Ship__png);
		this.x = Math.random() * (640 - this.width);
		this.y = -200;
		this.ty = 480 - Math.ffloor(Math.random() * this.height * 3) - 60;
	}
	
	override public function update():Void {
		super.update();
		this.y++;
		for (i in 0...Math.floor(Math.random() * 4)) {
			FlxG.state.add(new Smoke(this.x + 8 + Math.round(Math.random() * 13), this.y));
		}
		if (this.y + this.height >= ty) {
			FlxG.camera.flash(0xFFFFFFFF,3);
			FlxG.camera.shake(0.005,3);
			this.alive = false;
		}
	}
	
}