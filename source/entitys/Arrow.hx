package source.entitys;

import flixel.FlxSprite;
import AssetPaths;

/**
 * ...
 * @author Elliot Lee-Cerrino
 */
class Arrow extends FlxSprite
{

	public function new() 
	{
		super( -100, -100);
		this.loadGraphic(AssetPaths.arrow__png);
		this.visible = false;
	}
	
	override public function update():Void {
		if (Helper.selectedPop != null) {
			this.visible = true;
			this.x = Helper.selectedPop.x + Helper.selectedPop.width / 2 - this.width / 2;
			this.y = Helper.selectedPop.y - 20;
		}else {
			this.visible = false;
		}
	}
	
}