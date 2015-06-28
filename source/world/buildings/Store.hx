package source.world.buildings;

import source.world.Resource.Res;
import AssetPaths;
/**
 * ...
 * @author Elliot Lee-Cerrino
 */
class Store extends Building
{

	public function new(x:Float,y:Float) 
	{
		super(x, y);
		this.maximumStorage = 500;
		this.itemsInStore = new Map<EnumValue,Int>();
		this.itemsInStore.arrayWrite(Res.wood, 0);
		this.loadGraphic(AssetPaths.Store__png);
	}
}