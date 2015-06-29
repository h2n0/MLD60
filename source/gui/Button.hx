package source.gui;
import gui.GUI;
import AssetPaths;

/**
 * ...
 * @author Elliot Lee-Cerrino
 */
class Button extends GUI
{

	public function new(x:Float,y:Float,id:Int) 
	{
		super(x, y);
		this.loadGraphic(AssetPaths.Button__png);
		this.ID = id;
	}
	
}