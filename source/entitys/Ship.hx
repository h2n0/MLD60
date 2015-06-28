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

	public function new() 
	{
		super(-100, -100);
		this.loadGraphic(AssetPaths.Ship__png);
		this.x = flash.Lib.current.stage.width / 2 - this.width / 2;
		this.y = -200;
	}
	
	override public function update():Void {
		super.update();
		this.y++;
		for (i in 0...Math.floor(Math.random() * 4)) {
			FlxG.state.add(new Smoke(this.x + 8 + Math.round(Math.random() * 13), this.y));
		}
		if (this.y + this.height >= flash.Lib.current.stage.height - 100) {
			FlxG.camera.flash(0xFFFFFFFF,3);
			FlxG.camera.shake(0.005,3);
			this.alive = false;
		}
	}
	
}