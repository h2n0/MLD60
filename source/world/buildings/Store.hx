package source.world.buildings;

import source.world.Resource.Res;
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
	}
}