package source.world;

import flixel.FlxSprite;
import flixel.FlxG;

/**
 * ...
 * @author Elliot Lee-Cerrino
 */
class Building extends FlxSprite
{

	public var maximumStorage:Int;
	public var itemsInStore:Map<EnumValue,Int>;
	public function new(x:Float,y:Float) 
	{
		super(x, y);
		this.makeGraphic(64, 64, 0xFF777777);
		this.maximumStorage = 100;
		this.itemsInStore = new Map<EnumValue,Int>();
	}
	
	public function placeInStoreage(it:EnumValue, va:Int):Void {
		if (this.itemsInStore.exists(it)) {
			this.itemsInStore.arrayWrite(it, this.itemsInStore.get(it) + va);
		}else {
			this.itemsInStore.arrayWrite(it, va);
		}
	}
	
	public function getTotalUsedSpace():Int {
		var res:Int = 0;
		while (this.itemsInStore.keys().hasNext()) {
			res += this.itemsInStore.get(this.itemsInStore.keys().next());
		}
		return res;
	}
	
	public function getAmountOfSpecific(t:EnumValue):Int {
		if (this.itemsInStore.exists(t)) return this.itemsInStore.get(t);
		else return 0;
	}
	
	public function takesX(t:EnumValue):Bool {
		if (getAmountOfSpecific(t) == -1) return false;
		else return true;
	}
}